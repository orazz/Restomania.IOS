//
//  PlaceCartTotalContainerCell.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class PlaceCartTotalContainerCell: UITableViewCell {

    public static func create(for delegate: PlaceCartDelegate, title: String, _ action: @escaping ((CartService, MenuSummary) -> Price)) -> PlaceCartTotalContainerCell {

        let cell: PlaceCartTotalContainerCell = UINib.instantiate(from: "\(String.tag(PlaceCartTotalContainerCell.self))View", bundle: Bundle.main)

        cell.title = title
        cell.action = action
        cell.delegate = delegate
        cell.setupMarkup()
        cell.update()

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
    private var action: ((CartService, MenuSummary) -> Price)!
    private var cart: CartService {
        return delegate.takeCart()
    }

    private func update() {

        if let menu = delegate.takeMenu() {

            let sum = action(cart, menu)
            totalLabel.setup(price: sum, currency: menu.currency)
        }
    }
    private func setupMarkup() {

        self.backgroundColor = ThemeSettings.Colors.additional

        titleLabel.font = ThemeSettings.Fonts.default(size: .head)
        titleLabel.textColor = ThemeSettings.Colors.main
        titleLabel.text = title

        totalLabel.font = ThemeSettings.Fonts.bold(size: .head)
        totalLabel.textColor = ThemeSettings.Colors.main
        totalLabel.setup(amount: 0, currency: .RUB)
    }
}
extension PlaceCartTotalContainerCell: CartServiceDelegate {

    public func cart(_ cart: CartService, change dish: AddedOrderDish) {
        changeCart()
    }
    public func cart(_ cart: CartService, remove dish: AddedOrderDish) {
        changeCart()
    }
    private func changeCart() {

        DispatchQueue.main.async {
            self.update()
        }
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
        update()
    }
}
extension PlaceCartTotalContainerCell: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        return 45
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
