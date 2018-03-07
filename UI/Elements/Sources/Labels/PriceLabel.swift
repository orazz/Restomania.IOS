//
//  PriceLabel.swift
//  Kuzina
//
//  Created by Алексей on 24.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import CoreTools
import CoreDomains
import Localization
import UITools

open class PriceLabel: UILabel {

    //UI
    private var currencyFont: UIFont!

    //Services
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    //Data
    public private(set) var price = Price.zero
    public private(set) var currency = Currency.All
    public private(set) var useStartFrom: Bool = false

    public override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }
    public required init(coder: NSCoder) {
        super.init(coder: coder)!

        initialize()
    }
    private func initialize() {
        currencyFont = themeFonts.icons(size: UIFont.systemFontSize)
        
        refresh()
    }

    public func setup(price: Price, currency: Currency, useStartFrom: Bool = false) {
        self.price = price
        self.currency = currency
        self.useStartFrom = useStartFrom

        refresh()
    }
    public func setup(amount: Double, currency: Currency, useStartFrom: Bool = false) {
        setup(price: Price(double: amount), currency: currency, useStartFrom: useStartFrom)
    }
    public func clear() {
        self.text = String.empty
    }
    private func refresh() {

        if (price == Price.zero) {
            self.text = String.empty
        }

        let amount = format(price)
        let symbol = getSymbol(currency: currency)
        var text = "\(amount) \(symbol)"
        if (useStartFrom) {
            text = String(format: Localization.UIElements.PriceLabel.startFrom, text)
        }

        let characters = Array(text)
        let attributed = NSMutableAttributedString(string: text)
        attributed.addAttribute(NSAttributedStringKey.font,
                                value: currencyFont.withSize(floor(0.9 * font.pointSize)),
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
    private func getSymbol(currency: Currency) -> String {

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
