//
//  OrdersController.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 11.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary
import AsyncTask

public class ManagerOrdersController: UIViewController {

    // MARK: UI Elements
    @IBOutlet private weak var ordersTable: UITableView!
    private var interfaceLoader: InterfaceLoader!
    private var refreshControl: RefreshControl!

    // MARK: Tools
    private let _tag = String.tag(ManagerOrdersController.self)
    private var loadQueue: AsyncQueue!

    // MARK: Loaders
    private let ordersService = CacheServices.orders
    private var ordersContainer: PartsLoadTypedContainer<[DishOrder]>!
    private var orders = [DishOrder]()
    private var loaderAdapter: PartsLoader!

    // MARK: Life circle
    public init() {
        super.init(nibName: "ManagerOrdersControllerView", bundle: Bundle.main)

        loadQueue = AsyncQueue.createForControllerLoad(for: tag)

        ordersContainer = PartsLoadTypedContainer<[DishOrder]>(completeLoadHandler: self.completeLoad)
        ordersContainer.updateHandler = { update in
            let placeIds = AppSummary.shared.placeIDs!
            self.orders = update.filter({ placeIds.contains($0.placeId) }).sorted(by: self.sorter)

            DispatchQueue.main.async {
                self.ordersTable.reloadData()
            }
        }

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

        showNavigationBar()
        navigationItem.title = "Заказы"
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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

        let orders = ordersService.cache.all
        ordersContainer.update(orders)
        if (orders.isFilled) {
            ordersContainer.completeLoad()
        }

        if (loaderAdapter.noData || orders.isEmpty) {
            interfaceLoader.show()
        }

        requestOrders()
    }
    @objc private func needReload() {

        ordersContainer.startRequest()

        requestOrders()
    }
    private func requestOrders() {
        let request = ordersService.all()
        request.async(loadQueue, completion: ordersContainer.completeLoad)
    }
    private func completeLoad() {
        DispatchQueue.main.async {

            if (self.loaderAdapter.isLoad) {
                self.interfaceLoader.hide()
                self.refreshControl.endRefreshing()
            }
        }
    }
    private func sorter(left: DishOrder, right: DishOrder) -> Bool {
//        if (left.isCompleted && !right.isCompleted) {
//            return false
//        } else if (!left.isCompleted && right.isCompleted) {
//            return false
//        } else {
            return left.summary.completeAt > right.summary.completeAt
//        }
    }
    private func goToOrder(id orderId: Long) {

        if let orders = ordersContainer.data {
            let vc = ManagerOneOrderController.create(with: orders.find({ orderId == $0.ID })!)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
// MARK: Table
extension ManagerOrdersController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath) as! ManagerOrdersControllerOrderCell
        let orderId = cell.OrderId

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
