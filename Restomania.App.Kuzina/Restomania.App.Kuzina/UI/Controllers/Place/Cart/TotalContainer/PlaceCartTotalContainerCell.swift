//
//  PlaceCartTotalContainerCell.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class PlaceCartTotalContainerCell: UITableViewCell {

    private static let nibName = "PlaceCartTotalContainerCellView"
    public static func create(for delegate: PlaceCartDelegate, title: String, _ action: @escaping ((Cart, MenuSummary) -> Double)) -> PlaceCartTotalContainerCell {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let cell = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceCartTotalContainerCell

        cell.title = title
        cell.action = action
        cell.delegate = delegate
        cell.setupMarkup()
        cell.apply()

        return cell
    }

    //UI hooks
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var totalLabel: PriceLabel!

    //Data
    private let _tag = String.tag(PlaceCartTotalContainerCell.self)
    private let guid = Guid.new
    private var delegate: PlaceCartDelegate!
    private var title: String!
    private var action: ((Cart, MenuSummary) -> Double)!
    private var cart: Cart {
        return delegate.takeCart()
    }

    private func apply() {

        if let menu = delegate.takeMenu() {

            let sum = action(cart, menu)
            totalLabel.setup(amount: sum, currency: menu.currency)
        }
    }
    private func setupMarkup() {

        self.backgroundColor = ThemeSettings.Colors.additional

        titleLabel.font = ThemeSettings.Fonts.default(size: .head)
        titleLabel.textColor = ThemeSettings.Colors.main
        titleLabel.text = title

        totalLabel.font = ThemeSettings.Fonts.default(size: .subhead)
        totalLabel.textColor = ThemeSettings.Colors.main
        totalLabel.setup(amount: 0, currency: .RUB)
    }
}
extension PlaceCartTotalContainerCell: CartUpdateProtocol {
    public func cart(_ cart: Cart, changedDish: Dish, newCount: Int) {
        apply()
    }
    public func cart(_ cart: Cart, removedDish: Long) {
        apply()
    }
}
extension PlaceCartTotalContainerCell: PlaceCartContainerCell {
    public func viewDidAppear() {
        cart.subscribe(guid: guid, handler: self, tag: _tag)
    }
    public func viewDidDisappear() {
        cart.unsubscribe(guid: guid)
    }
    public func updateData(with: PlaceCartDelegate) {
        apply()
    }
}
extension PlaceCartTotalContainerCell: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        return 25
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
