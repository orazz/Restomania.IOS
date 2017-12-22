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

public protocol OrdersControllerProtocol {

}
public class ManagerOrdersController: UIViewController, OrdersControllerProtocol, UITableViewDelegate, UITableViewDataSource {

    // MARK: UI Elements
    @IBOutlet private weak var ordersTable: UITableView!
    private var interfaceLoader: InterfaceLoader!
    private var refreshControl: RefreshControl!

    // MARK: Tools
    private let _tag = String.tag(ManagerOrdersController.self)
    private var loadQueue: AsyncQueue!

    // MARK: Loaders
    private let ordersApi = ApiServices.Users.orders
    private var ordersContainer: PartsLoadTypedContainer<[DishOrder]>!
    private var loaderAdapter: PartsLoader!

    // MARK: Life circle
    public init() {
        super.init(nibName: "ManagerOrdersControllerView", bundle: Bundle.main)

        loadQueue = AsyncQueue.createForControllerLoad(for: tag)

        ordersContainer = PartsLoadTypedContainer<[DishOrder]>(completeLoadHandler: self.completeLoad)
        ordersContainer.updateHandler = { _ in
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

        interfaceLoader = InterfaceLoader(for: self.view)
        refreshControl = ordersTable.addRefreshControl(for: self, action: #selector(needReload))

        ordersTable.dataSource = self
        ordersTable.delegate = self
        ManagerOrdersControllerOrderCell.register(in: ordersTable)

        loadOrders()
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
    @objc private func needReload() {

    }
    private func loadOrders() {

        let request = ordersApi.all()
        request.async(loadQueue, completion: { response in

            if (response.isSuccess) {

                let placeIds = AppSummary.shared.placeIDs!

                let orders = response.data?.filter({ placeIds.contains($0.placeId)  }).sorted(by: { $0.ID > $1.ID })
            }

        })
    }
    private func completeLoad() {
        DispatchQueue.main.async {

            if (self.loaderAdapter.isLoad) {
                self.interfaceLoader.hide()
                self.refreshControl.endRefreshing()
            }
        }
    }
    private func goToOrder(id orderId: Long) {

        if let orders = ordersContainer.data {
            let vc = ManagerOneOrderController.create(with: orders.find({ orderId == $0.ID })!)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: OrdersControllerProtocol

    // MARK: UITableViewDelegate
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ManagerOrdersControllerOrderCell.identifier, for: indexPath) as! ManagerOrdersControllerOrderCell
//        cell.setup(order: orders[indexPath.row], delegate: self)

        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath) as! ManagerOrdersControllerOrderCell
        let orderId = cell.OrderId

        goToOrder(id: orderId)
    }

    // MARK: UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 0//orders.count
    }
}
