//
//  PlaceCartDishesContainerCell.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class PlaceCartDishesContainerCell: UITableViewCell {

    public static let height = CGFloat(40)
    private static let nibName = "PlaceCartDishesContainerCellView"
    public static func create(for dishId: Long, with cart: Cart, and menu: MenuSummary) -> PlaceCartDishesContainerCell {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let cell = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceCartDishesContainerCell

        cell.dishId = dishId
        cell.dish = menu.dishes.find({ $0.ID == dishId }) ?? Dish()
        cell.cart = cart
        cell.menu = menu
        cell.setupMarkup()
        cell.update(by: cart.find(dishId)?.count ?? 0)

        return cell
    }

    //UI hooks
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var totalLabel: PriceLabel!

    private func setupMarkup() {

        cart.subscribe(guid: guid, handler: self, tag: _tag)

        titleLabel.font = ThemeSettings.Fonts.default(size: .caption)
        titleLabel.textColor = ThemeSettings.Colors.main

        totalLabel.font = ThemeSettings.Fonts.bold(size: .caption)
        totalLabel.textColor = ThemeSettings.Colors.main
    }

    //Data
    private let _tag = String.tag(PlaceCartDishesContainerCell.self)
    private let guid = Guid.new
    private var dishId: Long!
    private var dish: Dish!
    private var count: Int!
    private var cart: Cart!
    private var menu: MenuSummary!

    private func update(by newCount: Int) {

        count =  newCount

        titleLabel.text = buildTitle()
        totalLabel.setup(amount: dish.price.double * count, currency: menu.currency)
    }
    private func buildTitle() -> String {

        return "\(count!) x \(dish.name)"
    }

    public func dispose() {
        cart.unsubscribe(guid: guid)
    }
}
// MARK: Actions
extension PlaceCartDishesContainerCell {

    @IBAction private func increment() {
        cart.add(dishId: dishId, count: 1)
    }
    @IBAction private func decrement() {
        cart.add(dishId: dishId, count: -1)
    }
}

// MARK: Cart
extension PlaceCartDishesContainerCell: CartUpdateProtocol {

    public func cart(_ cart: Cart, changedDish dishId: Long, newCount: Int) {
        change(dishId, on: newCount)
    }
    public func cart(_ cart: Cart, removedDish dishId: Long) {
        change(dishId, on: 0)
    }
    private func change(_ dishId: Long, on newCount: Int) {

        if (self.dishId == dishId) {

            DispatchQueue.main.async {
                self.update(by: newCount)
            }
        }
    }
}
