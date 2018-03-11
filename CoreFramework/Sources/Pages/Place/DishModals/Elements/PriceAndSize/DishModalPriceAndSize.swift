//
//  DishModalPriceAndSize.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class DishModalPriceAndSize: UITableViewCell {

    public static func create(for dish: BaseDish, from menu: MenuSummary) -> DishModalPriceAndSize {

        let cell: DishModalPriceAndSize = UINib.instantiate(from: "\(String.tag(DishModalPriceAndSize.self))View", bundle: Bundle.main)
        cell.update(by: dish, from: menu)

        return cell
    }

    //UI
    @IBOutlet private weak var onlyPriceLabel: PriceLabel!
    @IBOutlet private weak var priceLabel: PriceLabel!
    @IBOutlet private weak var dividerLabel: UILabel!
    @IBOutlet private weak var sizeLabel: SizeLabel!

    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    //Data
    private var isShowSizeAndPrice: Bool = false
    private var dish: BaseDish?
    private var menu: MenuSummary?

    public override func awakeFromNib() {
        super.awakeFromNib()

        onlyPriceLabel.font = themeFonts.bold(size: .head)
        onlyPriceLabel.textColor = themeColors.contentBackgroundText

        priceLabel.font = themeFonts.bold(size: .head)
        priceLabel.textColor = themeColors.contentBackgroundText

        sizeLabel.font = themeFonts.default(size: .subhead)
        sizeLabel.textColor = themeColors.contentBackgroundText
    }

    fileprivate func refresh() {

        isShowSizeAndPrice = false

        guard let dish = self.dish,
                let menu = self.menu else {
                return
        }

        if (dish.type == .simpleDish) {
            setup(price: dish.price, size: dish.size, units: dish.sizeUnits)

        } else if (dish.type == .variableDish) {
            let variations = menu.variations.filter({ $0.parentDishId == dish.id })
            if let variation = variations.min(by: { $0.price < $1.price }) {

                setup(price: variation.price, size: variation.size, units: dish.sizeUnits, dishType: dish.type)
            }
        }
    }
    private func setup(price: Price, size: Double, units: UnitsOfSize, dishType: DishType = .simpleDish) {

        guard let menu = self.menu else {
            return
        }

        if (abs(size) <= 0.0001) {

            onlyPriceLabel.isHidden = false
            priceLabel.isHidden = true
            dividerLabel.isHidden = true
            sizeLabel.isHidden = true
        } else {

            onlyPriceLabel.isHidden = true
            priceLabel.isHidden = false
            dividerLabel.isHidden = false
            sizeLabel.isHidden = false
        }

        let useStartFrom = dishType == .variableDish
        onlyPriceLabel.setup(price: price, currency: menu.currency, useStartFrom: useStartFrom)
        priceLabel.setup(price: price, currency: menu.currency, useStartFrom: useStartFrom)
        sizeLabel.setup(size: size, units: units, useStartFrom: useStartFrom)

        isShowSizeAndPrice = true
    }
}
extension DishModalPriceAndSize: DishModalElementsProtocol {
    public func update(by dish: BaseDish, from menu: MenuSummary) {
        self.dish = dish
        self.menu = menu

        refresh()
    }
}
extension DishModalPriceAndSize: InterfaceTableCellProtocol {
    public var viewHeight: Int {

        if isShowSizeAndPrice {
            return 30
        } else {
            return 0
        }
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
