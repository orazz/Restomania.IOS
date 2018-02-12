//
//  DishModalAddToCartAction.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import CoreDomains

public class DishModalAddToCartAction: UIView {

    //UI
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var actionLabel: UILabel!
    @IBOutlet private weak var totalLabel: PriceLabel!

    //Data
    private var delegate: AddDishToCartModalDelegateProtocol?

    public override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = ThemeSettings.Colors.main
        Bundle.main.loadNibNamed("\(String.tag(DishModalAddToCartAction.self))View", owner: self, options: nil)

        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.backgroundColor = ThemeSettings.Colors.main
        self.addSubview(contentView)

        actionLabel.font = ThemeSettings.Fonts.default(size: .title)
        actionLabel.textColor = ThemeSettings.Colors.additional
        actionLabel.text = Localization.DishModals.buttonsAddToCart.localized

        totalLabel.font = ThemeSettings.Fonts.bold(size: .head)
        totalLabel.textColor = ThemeSettings.Colors.additional
        totalLabel.isHidden = true
    }

    public func link(with delegate: AddDishToCartModalDelegateProtocol) {
        self.delegate = delegate
    }
    public func refresh(total: Price, with currency: CurrencyType) {

        totalLabel.isHidden = total.minorFormat == 0
        totalLabel.setup(price: total, currency: currency)
    }

    @IBAction private func addToCart() {
        delegate?.addToCart()
    }
}
