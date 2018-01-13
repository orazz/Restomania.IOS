//
//  PriceLabel.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 24.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit

public class PriceLabel: UILabel {

    //UI
    private var _font: UIFont!
    private var currencyFont: UIFont!

    //Data
    public private(set) var price = Price.zero
    public private(set) var currency = CurrencyType.All

    public override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }
    public required init(coder: NSCoder) {
        super.init(coder: coder)!

        initialize()
    }
    private func initialize() {
        currencyFont = ThemeSettings.Fonts.icons(size: UIFont.systemFontSize)

        refresh()
    }

    public func setup(price: Price, currency: CurrencyType) {
        self.price = price
        self.currency = currency

        refresh()
    }
    public func setup(amount: Double, currency: CurrencyType) {
        self.price = Price(double: amount)
        self.currency = currency

        refresh()
    }
    private func refresh() {

        if (price == Price.zero) {
            self.text = String.empty
        }

        let amount = format(price)
        let symbol = getSymbol(currency: currency)
        let text = "\(amount) \(symbol)"

        let characters = Array(text)
        let attributed = NSMutableAttributedString(string: text)
        attributed.addAttribute(NSAttributedStringKey.font,
                                value: currencyFont.withSize(floor(0.8 * font.pointSize)),
                                range: NSRange(location: characters.count - 1, length: 1))

        self.attributedText = attributed
    }
    private func format(_ price: Price) -> String {
        if (0 == price.float) {
            return "\(price.decimal)"

        } else if (0 == price.float % 10) {
            return "\(price.decimal).\(price.float / 10)"

        } else {
            return "\(price.decimal).\(price.float)"
        }
    }
    private func getSymbol(currency: CurrencyType) -> String {

        switch currency {
            case .RUB:
                return "\u{f158}"

            case .EUR:
                return "\u{f153}"

            case .USD:
                return "\u{f155}"

            default:
                return "\(currency)".uppercased()
        }
    }
}
