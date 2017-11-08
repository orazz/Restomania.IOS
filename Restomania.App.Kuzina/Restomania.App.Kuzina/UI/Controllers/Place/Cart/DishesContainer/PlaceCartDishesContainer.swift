//
//  PlaceCartDishesContainer.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class PlaceCartDishesContainer: UITableViewCell {

    private static let nibName = "PlaceCartDishesContainerView"
    public static func create(for delegate: PlaceCartDelegate) -> PlaceCartDishesContainer {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let cell = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceCartDishesContainer

        cell.delegate = delegate
        cell.setupMarkup()

        return cell
    }

    //UI elements
    @IBOutlet private weak var dishesTable: UITableView!
    private var cachedCells: [Long: PlaceCartDishesContainerCell] = [:]
    private func setupMarkup() {

        dishesTable.delegate = self
        dishesTable.dataSource = self
    }

    //Data
    private let _tag = String.tag(PlaceCartDishesContainer.self)
    private let guid = Guid.new
    private var delegate: PlaceCartDelegate!
    private var reloadHandler: (() -> Void)?
    private var menu: MenuSummary? {
        return delegate.takeMenu()
    }
    private var cart: Cart {
        return delegate.takeCart()
    }
    private var orderedDishes: [AddedOrderDish] = []

    private func update() {

        let newDishes = cart.dishes
        let needReload = orderedDishes.count != newDishes.count
         orderedDishes = newDishes
        if let _ = menu {
            dishesTable.reloadData()
        }

        if (needReload) {
            reloadHandler?()
        }
    }
}
// MARK: Table
extension PlaceCartDishesContainer: UITableViewDelegate {

}
extension PlaceCartDishesContainer: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedDishes.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let ordered = orderedDishes[indexPath.row]
        guard let cached = cachedCells[ordered.dishId] else {

            let cell = PlaceCartDishesContainerCell.create(for: ordered.dishId, with: self.cart, and: self.menu!)
            cachedCells[ordered.dishId] = cell

            return cell
        }

        return cached
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PlaceCartDishesContainerCell.height
    }
}
// MARK: Cart
extension PlaceCartDishesContainer: CartUpdateProtocol {

    public func cart(_ cart: Cart, changedDish dishId: Long, newCount: Int) {

        if nil == cachedCells[dishId] {
            reload()
        } else if (0 == newCount) {
            reload()
        }
    }
    public func cart(_ cart: Cart, removedDish dishId: Long) {
        reload()
    }
    private func reload() {
        DispatchQueue.main.async {
            self.update()
        }
    }
}
// MARK: Main
extension PlaceCartDishesContainer: PlaceCartContainerCell {

    public func viewDidAppear() {
        cart.subscribe(guid: guid, handler: self, tag: _tag)
    }
    public func viewDidDisappear() {
        cart.unsubscribe(guid: guid)
        clearCache()
    }
    public func updateData(with delegate: PlaceCartDelegate) {
        update()
    }
    private func clearCache() {

        _ = cachedCells.map({ $1.dispose() })
        cachedCells.removeAll()
    }
}
extension PlaceCartDishesContainer: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return Int(dishesTable.contentSize.height)
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
    public func addToContainer(handler: @escaping () -> Void) {
        self.reloadHandler = handler
    }
}
