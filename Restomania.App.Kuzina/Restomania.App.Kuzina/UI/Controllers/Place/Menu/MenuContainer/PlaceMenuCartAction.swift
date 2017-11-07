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
    public static func create(for cart: Cart, with navigationController: UINavigationController ) -> PlaceMenuCartAction {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceMenuCartAction

        instance._navigatior = navigationController
        instance._cart = cart
        instance.setupMarkup()

        return instance
    }

    //UI elements
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var totalLabel: PriceLabel!
    @IBAction private func goToCart() {

        guard let cart = _cart else {
            return
        }

//        let vc = PlaceCartController(for: cart.placeID)
//        _navigatior?.popToViewController(vc, animated: true)
    }

    //Data & services
    private let _tag = String.tag(PlaceMenuCartAction.self)
    private let _guid = Guid.new
    private var _navigatior: UINavigationController?
    private var _currency = CurrencyType.All
    private var _cart: Cart? {
        didSet {
            if let cart = _cart {
                apply(cart)
            }
        }
    }

    public func viewDidAppear() {
        _cart?.subscribe(guid: _guid, handler: self, tag: _tag)
    }
    public func viewDidDisappear() {
        _cart?.unsubscribe(guid: _guid)
    }
    public func update(currency: CurrencyType) {

        _currency = currency
        if let cart = _cart {
            apply(cart)
        }
    }

    private func apply(_ cart: Cart) {

        DispatchQueue.main.async {
            self.countLabel.text = "\(cart.dishes.sum({ $0.Count }))"
            self.totalLabel.setup(amount: cart.totalPrice, currency: self._currency)
        }
    }
    private func setupMarkup() {

        self.backgroundColor = ThemeSettings.Colors.main

        countLabel.textColor = ThemeSettings.Colors.additional
        countLabel.font = ThemeSettings.Fonts.default(size: .title)

        titleLabel.textColor = ThemeSettings.Colors.additional
        titleLabel.font = ThemeSettings.Fonts.default(size: .title)

        totalLabel.textColor = ThemeSettings.Colors.additional
        totalLabel.font = ThemeSettings.Fonts.default(size: .head)
    }
}

extension PlaceMenuCartAction: CartUpdateProtocol {
    public func cart(_ cart: Cart, changedDish: Dish, newCount: Int) {
        apply(cart)
    }
    public func cart(_ cart: Cart, removedDish: Long) {
        apply(cart)
    }
}
