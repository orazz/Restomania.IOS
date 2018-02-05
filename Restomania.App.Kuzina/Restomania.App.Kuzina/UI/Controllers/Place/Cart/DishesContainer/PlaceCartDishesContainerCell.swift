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

    public static let height = CGFloat(50)
    private static let nibName = "PlaceCartDishesContainerCellView"
    public static func create(for dish: AddedOrderDish, with cart: CartService, and menu: MenuSummary) -> PlaceCartDishesContainerCell {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let cell = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceCartDishesContainerCell

        cell.dish = dish
        if let source = menu.dishes.find({ $0.ID == dish.dishId }) {

            if (source.type == .simpleDish) {
                cell.dishName = source.name
            } else if source.type == .variableDish,
                    let variationiId = dish.variationId,
                    let variation = menu.variations.find({ $0.ID == variationiId }) {
                cell.dishName = variation.name
            }
        }
        cell.cart = cart
        cell.menu = menu

        cell.refresh()

        return cell
    }

    //UI hooks
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var totalLabel: PriceLabel!
    @IBOutlet private weak var titleContainer: UIView!
    @IBOutlet private weak var addingsTable: UITableView!

    public override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel.font = ThemeSettings.Fonts.default(size: .caption)
        titleLabel.textColor = ThemeSettings.Colors.main

        totalLabel.font = ThemeSettings.Fonts.default(size: .subhead)
        totalLabel.textColor = ThemeSettings.Colors.main

        addingsTable.delegate = self
        addingsTable.dataSource = self
        PlaceCartDishesContainerCellMeta.register(in: addingsTable)
    }

    //Data
    private let _tag = String.tag(PlaceCartDishesContainerCell.self)
    private let guid = Guid.new

    private var dish: AddedOrderDish!
    private var dishName: String = String.empty
    private var addings: [Dish] = []
    private var menu: MenuSummary!
    private var cart: CartService!

    private func refresh() {

        titleLabel.text = "\(dish.count) x \(dishName)"
        totalLabel.setup(price: dish.total(with: menu), currency: menu.currency)

        addings = dish.additions.map({ menu.dishes.find(id: $0) })
                                 .filter({ nil != $0 })
                                 .map({ $0! })
        addingsTable.reloadData()
    }
}
// MARK: Actions
extension PlaceCartDishesContainerCell {

    @IBAction private func increment() {
        cart.increment(dish)
    }
    @IBAction private func decrement() {
        cart.decrement(dish)
    }
}
extension PlaceCartDishesContainerCell: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addings.count
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PlaceCartDishesContainerCellMeta.height
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: PlaceCartDishesContainerCellMeta.identifier, for: indexPath) as! PlaceCartDishesContainerCellMeta
        cell.setup(dish: addings[indexPath.row], with: menu)

        return cell
    }
}
extension PlaceCartDishesContainerCell: PlaceCartContainerCell {
    public func viewDidAppear() {
        cart.subscribe(guid: guid, handler: self, tag: _tag)
    }
    public func viewDidDisappear() {
        cart.unsubscribe(guid: guid)
    }
    public func updateData(with: PlaceCartDelegate) {}
}
extension PlaceCartDishesContainerCell: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return Int(titleContainer.frame.height) + addings.count * Int(PlaceCartDishesContainerCellMeta.height)
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
//Cart
extension PlaceCartDishesContainerCell: CartServiceDelegate {

    public func cart(_ cart: CartService, change dish: AddedOrderDish) {
        change(dish)
    }
    public func cart(_ cart: CartService, remove dish: AddedOrderDish) {
        change(dish)
    }
    private func change(_ dish: AddedOrderDish) {

        if (self.dish === dish) {
            DispatchQueue.main.async {
                self.refresh()
            }
        }
    }
}
