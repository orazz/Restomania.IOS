//
//  OrdersController.swift
//  CoreFramework
//
//  Created by Алексей on 11.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class OrdersController: UIViewController {

    // MARK: UI Elements
    @IBOutlet private weak var ordersTable: UITableView!
    private var interfaceLoader: InterfaceLoader!
    private var refreshControl: RefreshControl!

    // MARK: Tools
    private let _tag = String.tag(OrdersController.self)
    private let guid = Guid.new
    private var loadQueue: AsyncQueue!

    // MARK: Loaders
    private let ordersService = DependencyResolver.resolve(OrdersCacheService.self)
    private let apiKeysService = DependencyResolver.resolve(ApiKeyService.self)
    private let configs = DependencyResolver.resolve(ConfigsContainer.self)
    private var ordersContainer: PartsLoadTypedContainer<[DishOrder]>!
    private var orders = [DishOrder]()
    private var loaderAdapter: PartsLoader!

    // MARK: Life circle
    public init() {
        super.init(nibName: String.tag(OrdersController.self), bundle: Bundle.coreFramework)

        loadQueue = AsyncQueue.createForControllerLoad(for: tag)

        ordersContainer = PartsLoadTypedContainer<[DishOrder]>(updateHandler: displayOrders, completeLoadHandler: completeLoad)
        loaderAdapter = PartsLoader([ordersContainer])
    }
    public convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    public override func loadView() {
        super.loadView()

        loadMarkup()
    }
    public override func viewDidLoad() {
        super.viewDidLoad()

        loadData()

        ordersService.subscribe(guid: guid, handler: self, tag: _tag)
        apiKeysService.subscribe(guid: guid, handler: self, tag: _tag)
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = Keys.title.localized

        displayCachedOrders()
    }

    // MARK: Process methods
    private func loadMarkup() {

        interfaceLoader = InterfaceLoader(for: self.view)
        refreshControl = ordersTable.addRefreshControl(for: self, action: #selector(needReload))

        ordersTable.dataSource = self
        ordersTable.delegate = self
        OrdersControllerOrderCell.register(in: ordersTable)
    }
    private func loadData() {
        displayCachedOrders()

        if (orders.isEmpty) {
            interfaceLoader.show()
        }

        requestOrders()
    }
    @objc private func needReload() {
        ordersContainer.startRequest()
        requestOrders()
    }
    private func requestOrders() {

        if (!apiKeysService.isAuth) {
            interfaceLoader.hide()
            refreshControl.endRefreshing()
            return
        }

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
extension OrdersController: OrdersCacheServiceDelegate {
    public func update(_ orderId: Long, update: DishOrder) {
        displayCachedOrders()

        for cell in ordersTable.visibleCells {
            if let cell = cell as? OrdersControllerOrderCell {
                if (cell.orderId == orderId) {
                    DispatchQueue.main.async {
                        cell.update(by: update)
                    }
                    break
                }
            }
        }
    }
    public func update(range: [DishOrder]) {
        displayCachedOrders()
    }
    private func displayCachedOrders() {

        if (!apiKeysService.isAuth) {
            return
        }

        let orders = ordersService.cache.all
        self.ordersContainer.update(orders)
    }
}
// MARK: Table
extension OrdersController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath) as! OrdersControllerOrderCell
        let orderId = cell.orderId

        goToOrder(id: orderId)
    }
}
extension OrdersController: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: OrdersControllerOrderCell.identifier, for: indexPath) as! OrdersControllerOrderCell
        cell.update(by: orders[indexPath.row])

        return cell
    }
}

//Api keys
extension OrdersController: ApiKeyServiceDelegate {
    public func apiKeyService(_ service: ApiKeyService, logout role: ApiRole) {

        DispatchQueue.main.async {
            self.orders.removeAll()
            self.ordersTable.reloadData()
        }
    }
}

//Localization
extension OrdersController {
    public enum Keys: String, Localizable {

        public var tableName: String {
            return String.tag(OrdersController.self)
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
