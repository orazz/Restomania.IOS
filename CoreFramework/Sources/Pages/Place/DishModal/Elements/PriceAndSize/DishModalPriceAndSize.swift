//
//  DishModalPriceAndSize.swift
//  CoreFramework
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class DishModalPriceAndSize: UITableViewCell {

    public static func create(for dish: ParsedDish) -> DishModalPriceAndSize {

        let nibname = String.tag(DishModalPriceAndSize.self)
        let cell: DishModalPriceAndSize = UINib.instantiate(from: nibname, bundle: Bundle.coreFramework)
        cell.update(by: dish)

        return cell
    }

    //UI
    @IBOutlet private weak var onlyPriceLabel: PriceLabel!
    @IBOutlet private weak var priceLabel: PriceLabel!
    @IBOutlet private weak var dividerLabel: UILabel!
    @IBOutlet private weak var sizeLabel: SizeLabel!

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    //Data
    private var isShowSizeAndPrice: Bool = false
    private var dish: ParsedDish?

    public override func awakeFromNib() {
        super.awakeFromNib()

        onlyPriceLabel.font = themeFonts.bold(size: .head)
        onlyPriceLabel.textColor = themeColors.contentText

        priceLabel.font = themeFonts.bold(size: .head)
        priceLabel.textColor = themeColors.contentText

        sizeLabel.font = themeFonts.default(size: .subhead)
        sizeLabel.textColor = themeColors.contentText
    }

    fileprivate func refresh() {

        isShowSizeAndPrice = false

        guard let dish = self.dish else {
                return
        }

        switch dish.type {
            case .simpleDish:
                setup(price: dish.price, size: dish.size, units: dish.sizeUnits)

            case .variableDish:
                if let minPrice = dish.variation?.minPrice,
                    let minSize = dish.variation?.minSize,
                    let minSizeUnits = dish.variation?.minSizeUnits {
                    setup(price: minPrice, size: minSize, units: minSizeUnits, dishType: dish.type)
                }

            default:
                return
        }
    }
    private func setup(price: Price, size: Double, units: UnitsOfSize, dishType: DishType = .simpleDish) {

        guard let dish = self.dish else {
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
        onlyPriceLabel.setup(price: price, currency: dish.currency, useStartFrom: useStartFrom)
        priceLabel.setup(price: price, currency: dish.currency, useStartFrom: useStartFrom)
        sizeLabel.setup(size: size, units: units, useStartFrom: useStartFrom)

        isShowSizeAndPrice = true
    }
}
extension DishModalPriceAndSize: DishModalElementProtocol {
    public func update(by dish: ParsedDish) {
        self.dish = dish

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
