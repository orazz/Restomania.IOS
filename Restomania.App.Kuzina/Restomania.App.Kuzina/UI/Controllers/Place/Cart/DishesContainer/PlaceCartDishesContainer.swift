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

    public static func create(for delegate: PlaceCartDelegate) -> PlaceCartDishesContainer {

        let nibName = "PlaceCartDishesContainerView"
        let cell: PlaceCartDishesContainer = UINib.instantiate(from: nibName, bundle: Bundle.main)

        cell.delegate = delegate

        return cell
    }

    //UI elements
    @IBOutlet private weak var dishesTable: UITableView!
    private var dishesAdapter: InterfaceTable!
    private var rows: [PlaceCartDishesContainerCell] = []

    //Data
    private let _tag = String.tag(PlaceCartDishesContainer.self)
    private let guid = Guid.new
    private var delegate: PlaceCartDelegate!
    private var reloadHandler: (() -> Void)?
    private var menu: MenuSummary? {
        return delegate.takeMenu()
    }
    private var cart: CartService {
        return delegate.takeCart()
    }

    private func update() {

        let needReload = rows.count != cart.dishesCount

        rows.each({ $0.viewDidDisappear() })
        rows.each({ $0.removeFromSuperview() })
        rows.removeAll()
        if let menu = self.menu {
            for dish in cart.dishes {
                rows.append(PlaceCartDishesContainerCell.create(for: dish, with: cart, and: menu))
            }

            rows.each({ $0.viewDidAppear() })
            dishesAdapter = InterfaceTable(source: dishesTable, rows: rows)
            dishesAdapter.reload()
        }

        if (needReload) {
            reloadHandler?()
        }
    }
}
// MARK: Cart
extension PlaceCartDishesContainer: CartServiceDelegate {

    public func cart(_ cart: CartService, change dish: AddedOrderDish) {
        if dish.count == 1 {
            reload()
        }
    }
    public func cart(_ cart: CartService, remove dish: AddedOrderDish) {
        reload()
    }
    private func reload() {
        DispatchQueue.main.async {
            self.update()
        }
    }
}
// PlaceCartContainerCell
extension PlaceCartDishesContainer: PlaceCartContainerCell {

    public func viewDidAppear() {
        cart.subscribe(guid: guid, handler: self, tag: _tag)

        rows.each({ $0.viewDidAppear() })
    }
    public func viewDidDisappear() {
        cart.unsubscribe(guid: guid)

        rows.each({ $0.viewDidDisappear() })
    }
    public func updateData(with delegate: PlaceCartDelegate) {
        update()

        rows.each({ $0.updateData(with: delegate) })
    }
}
extension PlaceCartDishesContainer: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return rows.sum({ $0.viewHeight })
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
    public func addToContainer(handler: @escaping () -> Void) {
        self.reloadHandler = handler
    }
}
