//
//  OrdersController.swift
//  Kuzina
//
//  Created by Алексей on 11.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class ManagerOrdersController: UIViewController {

    // MARK: UI Elements
    @IBOutlet private weak var ordersTable: UITableView!
    private var interfaceLoader: InterfaceLoader!
    private var refreshControl: RefreshControl!

    // MARK: Tools
    private let _tag = String.tag(ManagerOrdersController.self)
    private let guid = Guid.new
    private var loadQueue: AsyncQueue!

    // MARK: Loaders
    private let ordersService = DependencyResolver.resolve(OrdersCacheService.self)
    private var ordersContainer: PartsLoadTypedContainer<[DishOrder]>!
    private var orders = [DishOrder]()
    private var loaderAdapter: PartsLoader!
    private let configs = DependencyResolver.resolve(ConfigsContainer.self)

    // MARK: Life circle
    public init() {
        super.init(nibName: "ManagerOrdersControllerView", bundle: Bundle.coreFramework)

        loadQueue = AsyncQueue.createForControllerLoad(for: tag)

        ordersContainer = PartsLoadTypedContainer<[DishOrder]>(updateHandler: displayOrders, completeLoadHandler: completeLoad)
        loaderAdapter = PartsLoader([ordersContainer])
    }
    public convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    public override func viewDidLoad() {
        super.viewDidLoad()

        loadMarkup()
        loadData()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.title = Keys.title.localized

        displayCachedOrders()
        ordersService.subscribe(guid: guid, handler: self, tag: tag)
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        ordersService.unsubscribe(guid: guid)
    }

    // MARK: Process methods
    private func loadMarkup() {

        interfaceLoader = InterfaceLoader(for: self.view)
        refreshControl = ordersTable.addRefreshControl(for: self, action: #selector(needReload))

        ordersTable.dataSource = self
        ordersTable.delegate = self
        ManagerOrdersControllerOrderCell.register(in: ordersTable)
    }
    private func loadData() {
        displayCachedOrders()

        if (loaderAdapter.noData) {
            interfaceLoader.show()
        }

        requestOrders()
    }
    @objc private func needReload() {
        ordersContainer.startRequest()
        requestOrders()
    }
    private func requestOrders() {

        let request = ordersService.all(chainId: configs.chainId, placeId: configs.placeId)
        request.async(loadQueue, completion: ordersContainer.completeLoad)
    }
    private func completeLoad() {
        DispatchQueue.main.async {

            if (self.loaderAdapter.isLoad) {
                self.interfaceLoader.hide()
                self.refreshControl.endRefreshing()

                if (self.loaderAdapter.problemWithLoad) {
                    self.showToast(Keys.loadError)
                }
            }
        }
    }
    private func displayOrders(_ orders: [DishOrder]) {

        self.orders = orders.sorted(by: self.sorter)

        DispatchQueue.main.async {
            self.ordersTable.reloadData()
        }
    }
    private func sorter(left: DishOrder, right: DishOrder) -> Bool {
        return left.id > right.id
    }
    private func goToOrder(id orderId: Long) {

        let vc = OneOrderController(for: orderId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: Orders delegate
extension ManagerOrdersController: OrdersCacheServiceDelegate {
    public func update(_ orderId: Long, update: DishOrder) {
        displayCachedOrders()

        for cell in ordersTable.visibleCells {
            if let cell = cell as? ManagerOrdersControllerOrderCell {
                if (cell.orderId == orderId) {
                    cell.update(by: update)
                    break
                }
            }
        }
    }
    public func update(range: [DishOrder]) {
        displayCachedOrders()
    }
    private func displayCachedOrders() {
        let orders = ordersService.cache.all
        self.ordersContainer.update(orders)
    }
}
// MARK: Table
extension ManagerOrdersController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath) as! ManagerOrdersControllerOrderCell
        let orderId = cell.orderId

        goToOrder(id: orderId)
    }
}
extension ManagerOrdersController: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ManagerOrdersControllerOrderCell.identifier, for: indexPath) as! ManagerOrdersControllerOrderCell
        cell.update(by: orders[indexPath.row])

        return cell
    }
}
//Localization
extension ManagerOrdersController {
    public enum Keys: String, Localizable {

        public var tableName: String {
            return String.tag(ManagerOrdersController.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        case title = "Title"

        case idFormat = "Formats.Id"
        case dateAndTimeFormat = "Formats.DateAndTime"

        case loadError = "Errors.Load"
    }
}
