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

public protocol OrdersControllerProtocol {

}
public class OrdersController: UIViewController, OrdersControllerProtocol, UITableViewDelegate, UITableViewDataSource {

    public static let nibName = "OrdersView"

    //UI Elements
    @IBOutlet weak var TableView: UITableView!

    //Tools 
    private var _loader: InterfaceLoader!
    private var _apiService: UserOrdersApiService!
    private var _orders: [DishOrder] = [DishOrder]()

    public init() {
        super.init(nibName: OrdersController.nibName, bundle: Bundle.main)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        _loader = InterfaceLoader(for: self.view)

        let keys = ServicesManager.current.keysStorage
        _apiService = UserOrdersApiService(storage: keys)

        let nib = UINib(nibName: OrderCell.nibName, bundle: Bundle.main)
        TableView.register(nib, forCellReuseIdentifier: OrderCell.identifier)
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        showNavigationBar()
        navigationItem.title = "Заказы"

        loadOrders()
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        hideNavigationBar()
    }

    // MARK: Process methods
    private func loadOrders() {

        let placeIds = AppSummary.current.placeIDs!

        _loader.show()

        let request = _apiService.All()
        request.async(.background, completion: { response in

            DispatchQueue.main.async {

                if (!response.isSuccess) {

                    Log.Warning(self.getTag(), "Problem with getting orders.")
                } else {

                    let orders = response.data?.filter({ placeIds.contains($0.Summary.PlaceID)  })

                    self._orders = orders!
                    self.TableView.reloadData()
                }

                self._loader.hide()
            }
        })

    }
    private func goToOrder(id orderId: Long) {

        let controller = OneOrderController(with: _orders.find({ orderId == $0.ID })!)

        self.navigationController?.pushViewController(controller, animated: true)
    }

    // MARK: OrdersControllerProtocol

    // MARK: UITableViewDelegate
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.identifier, for: indexPath) as! OrderCell
        cell.setup(order: _orders[indexPath.row], delegate: self)

        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath) as! OrderCell
        let orderId = cell.OrderId

        goToOrder(id: orderId)
    }

    // MARK: UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return _orders.count
    }
}
