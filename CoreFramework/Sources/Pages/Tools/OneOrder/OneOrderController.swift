//
//  OneOrderController.swift
//  CoreFramework
//
//  Created by Алексей on 11.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public protocol OneOrderInterfacePart: InterfaceTableCellProtocol {
    func update(by: DishOrder)
}
public class OneOrderController: UIViewController {

    //UI Elements
    @IBOutlet private weak var cancelButton: BottomAction!
    @IBOutlet private weak var interfaceTable: UITableView!
    private var interfaceAdapter: InterfaceTable!
    private var interfaceParts: [OneOrderInterfacePart] = []
    private var interfaceLoader: InterfaceLoader!
    private var refreshControl: RefreshControl!

    //Services
    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)
    private let ordersService = DependencyResolver.resolve(OrdersCacheService.self)
    private var orderContainer: PartsLoadTypedContainer<DishOrder>!
    private var partsLoader: PartsLoader!

    //Data
    private let _tag = String.tag(OneOrderController.self)
    private let guid = Guid.new
    private var loadQueue: AsyncQueue!
    private var orderId: Long!

    // MARK: Life circle
    public convenience init(for order: DishOrder) {
        self.init(for: order.id)

        orderContainer.update(order)
    }
    public init(for orderId: Long) {
        super.init(nibName: String.tag(OneOrderController.self), bundle: Bundle.coreFramework)

        self.orderId = orderId

        self.orderContainer = PartsLoadTypedContainer<DishOrder>(updateHandler: applyOrder, completeLoadHandler: completeLoad)
        self.partsLoader = PartsLoader([orderContainer])

        self.loadQueue = AsyncQueue.createForControllerLoad(for: tag)
    }
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(for: -1)
    }

    public override func loadView() {
        super.loadView()


        view.backgroundColor = themeColors.contentDivider

        interfaceLoader = InterfaceLoader(for: self.view)
        interfaceTable.backgroundColor = themeColors.contentDivider

        refreshControl = interfaceTable.addRefreshControl(for: self, action: #selector(needReload))
        refreshControl.backgroundColor = themeColors.contentDivider
        refreshControl.tintColor = themeColors.contentDividerText

        cancelButton.setTitle(Keys.cancelOrderButton.localized, for: .normal)

        interfaceParts = loadParts()
        interfaceAdapter = InterfaceTable(source: interfaceTable, navigator: self.navigationController!, rows: interfaceParts)
    }
    override public func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.title = String(format: Keys.title.localized, orderId!)

        self.ordersService.subscribe(guid: guid, handler: self, tag: tag)
    }
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        ordersService.unsubscribe(guid: guid)
    }
}
//Load
extension OneOrderController {
    private func loadParts() -> [OneOrderInterfacePart] {

        var result = [OneOrderInterfacePart]()

        result.append(OneOrderSpaceContainer.create())
        result.append(OneOrderSummaryContainer.create())

        result.append(OneOrderSpaceContainer.create())
        result.append(OneOrderDishesContainer.instance)
        result.append(OneOrderTotalContainer.instance)

        result.append(OneOrderAddedAtContainer.instance)

        result.append(OneOrderSpaceContainer.create())
        result.append(OneOrderCommentContainer.instance)
        
        result.append(OneOrderSpaceContainer.create())

        return result
    }
    @objc private func needReload() {
        requestData()
    }
    private func loadData() {
        if let cached = ordersService.cache.find(orderId) {
            orderContainer.updateAndCheckFresh(cached, cache: ordersService.cache)
        } else {
            interfaceLoader.show()
        }

        if (!ordersService.cache.isFresh(orderId)) {
            requestData()
        }
    }
    private func requestData() {
        orderContainer.startRequest()

        requestOrder()
    }
    private func requestOrder() {
        let request = ordersService.find(orderId)
        request.async(loadQueue, completion: orderContainer.completeLoad)
    }
    @objc private func completeLoad() {
        DispatchQueue.main.async {

            if (self.partsLoader.isLoad) {
                self.refreshControl.endRefreshing()
                self.interfaceLoader.hide()

                if (self.partsLoader.problemWithLoad) {
                    self.showToast(Keys.problemWithLoad)
                }
            }
        }
    }
    private func applyOrder(_ order: DishOrder) {

        DispatchQueue.main.async {
            self.cancelButton.isHidden = order.isCompleted

            for part in self.interfaceParts {
                part.update(by: order)
            }

            self.interfaceAdapter.reload()
        }
    }
}

extension OneOrderController {
    @IBAction private func cancelOrder() {

        guard let order = orderContainer.data else {
            return
        }

        let oldStatus = order.status
        order.status = DishOrderStatus.canceledByUser
        orderContainer.update(order)

        let request = ordersService.cancel(orderId)
        request.async(loadQueue) { response in

            if (response.isFail) {
                DispatchQueue.main.async {
                    order.status = oldStatus
                    self.orderContainer.update(order)

                    self.showToast(Keys.problemWithCancel)
                }
            }
        }
    }
}
extension OneOrderController: OrdersCacheServiceDelegate {
    public func update(range: [DishOrder]) {

        for update in range {
            if (update.id == orderId) {
                orderContainer.update(update)
                break
            }
        }
    }
    public func update(_ orderId: Long, update: DishOrder) {

        if (orderId == self.orderId) {
            orderContainer.update(update)
        }
    }
}
extension OneOrderController {
    public enum Keys: String, Localizable {
        public var tableName: String {
            return String.tag(OneOrderController.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        case title = "Title"

        case cancelOrderButton = "Buttons.CancelOrder"

        case completeAtLabel = "Labels.CompleteAt"

        case codewordTitleLabel = "Labels.Codeword"
        case placeNameTitleLabel = "Labels.PlaceName"
        case statusTitleLabel = "Labels.Status"

        case totalLabel = "Labels.Total"
        case createAtLabel = "Labels.CreateAt"

        case commentLabel = "Labels.Comment"

        case timeFormat = "Formats.Time"
        case dateFormat = "Formats.Date"

        case statusProcessing = "DishOrder.Status.Processing"
        case statusWaitingPayment = "DishOrder.Status.WaitingPayment"
        case statusMaking = "DishOrder.Status.Making"
        case statusPrepared = "DishOrder.Status.Prepared"
        case statusPaymentFail = "DishOrder.Status.PaymentFail"
        case statusCompleted = "DishOrder.Status.Completed"
        case statusCanceledByPlace = "DishOrder.Status.CanceledByPlace"
        case statusCanceledByUser = "DishOrder.Status.CanceledByUser"

        case problemWithLoad = "Messages.ProblemWithLoad"
        case problemWithCancel = "Messages.ProblemWithCancel"
    }
}
