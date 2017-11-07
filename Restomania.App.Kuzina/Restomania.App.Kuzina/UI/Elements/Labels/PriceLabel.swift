//
//  PriceLabel.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 24.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit

public class PriceLabel: UILabel {

    public class Price {

        public let amount: Double
        public let currency: CurrencyType

        public init(amount: Double, currency: CurrencyType) {

            self.amount = amount
            self.currency = currency
        }
    }

    public var price: Price? {
        return _price
    }

    private var _font: UIFont!
    private var _fontAwesome: UIFont!
    private var _price: Price?

    public override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }
    public required init(coder: NSCoder) {
        super.init(coder: coder)!

        initialize()
    }
    private func initialize() {

        _font = self.font
        _fontAwesome = ThemeSettings.Fonts.icons(size: UIFont.systemFontSize)

        refreshText()
    }

    public func setup(amount: Double, currency: CurrencyType) {

        _price = Price(amount: amount, currency: currency)
        refreshText()
    }
    private func refreshText() {

        guard let price = _price else {

            self.text = String.empty
            return
        }

        let amount = format(amount: price.amount)
        let symbol = getSymbol(currency: price.currency)
        let text = "\(amount) \(symbol)"

        let characters = Array(text)
        let attributed = NSMutableAttributedString(string: text)
        attributed.addAttribute(NSAttributedStringKey.font,
                                value: _fontAwesome.withSize( 0.8 * _font.pointSize),
                                range: NSRange(location: characters.count - 1, length: 1))

        self.attributedText = attributed
    }
    private func format(amount value: Double) -> String {

        let sign = value < 0 ? -1 : 1
        let value = abs(value)
        let decimal = Int(floor(value)) * sign

        let diffent = value - Double(decimal)
        let float = Int(round(diffent * 100))

        if (0 == float) {

            return "\(decimal)"

        } else if (0 == float % 10) {

            return "\(decimal).\(float / 10)"
        } else {

            return "\(decimal).\(float)"
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
