//
//  PlaceMenuCartAction.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 07.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class PlaceMenuCartAction: UIView {

    private static let nibName = "PlaceMenuCartActionView"
    public static func create(with delegate: PlaceMenuDelegate) -> PlaceMenuCartAction {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceMenuCartAction

        instance.delegate = delegate
        instance.menu = delegate.takeMenu()
        instance.cart = delegate.takeCart()

        instance.apply()

        return instance
    }

    //UI elements
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var totalLabel: PriceLabel!
    @IBAction private func goToCart() {
        delegate.goToCart()
    }

    //Data & services
    private let _tag = String.tag(PlaceMenuCartAction.self)
    private let guid = Guid.new
    private var currency = CurrencyType.All
    private var delegate: PlaceMenuDelegate!
    private var menu: MenuSummary? {
        didSet {
            if let menu = menu {
                currency = menu.currency
            }
        }
    }
    private var cart: CartService!

    public func viewDidAppear() {
        cart.subscribe(guid: guid, handler: self, tag: _tag)
    }
    public func viewDidDisappear() {
        cart.unsubscribe(guid: guid)
    }
    public func update(new menu: MenuSummary) {
        self.menu = menu

        apply()
    }

    private func apply() {

        DispatchQueue.main.async {
            self.countLabel.text = "\(self.cart.dishes.sum({ $0.count }))"

            if let menu = self.menu {
                self.totalLabel.setup(price: self.cart.total(with: menu), currency: self.currency)
            }
        }
    }
    public override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = ThemeSettings.Colors.main

        countLabel.textColor = ThemeSettings.Colors.additional
        countLabel.font = ThemeSettings.Fonts.default(size: .title)

        titleLabel.text = PlaceMenuController.Keys.ToCart.localized
        titleLabel.textColor = ThemeSettings.Colors.additional
        titleLabel.font = ThemeSettings.Fonts.default(size: .title)

        totalLabel.textColor = ThemeSettings.Colors.additional
        totalLabel.font = ThemeSettings.Fonts.default(size: .head)
    }
}

extension PlaceMenuCartAction: CartServiceDelegate {
    public func cart(_ cart: CartService, change dish: AddedOrderDish) {
        apply()
    }
    public func cart(_ cart: CartService, remove dish: AddedOrderDish) {
        apply()
    }
}
