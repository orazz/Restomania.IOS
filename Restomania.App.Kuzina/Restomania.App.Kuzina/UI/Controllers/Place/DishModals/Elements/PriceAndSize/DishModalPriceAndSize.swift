//
//  DishModalPriceAndSize.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class DishModalPriceAndSize: UITableViewCell {

    public static func create(for dish: BaseDish, from menu: MenuSummary) -> DishModalPriceAndSize {

        let cell: DishModalPriceAndSize = UINib.instantiate(from: "\(String.tag(DishModalPriceAndSize.self))View", bundle: Bundle.main)
        cell.update(by: dish, from: menu)

        return cell
    }

    //UI
    @IBOutlet private weak var priceLabel: PriceLabel!
    @IBOutlet private weak var sizeLabel: UILabel!

    //Data
    private var isShowSizeAndPrice: Bool = false
    private var dish: BaseDish?
    private var menu: MenuSummary?

    public override func awakeFromNib() {
        super.awakeFromNib()

        priceLabel.font = ThemeSettings.Fonts.bold(size: .head)
        priceLabel.textColor = ThemeSettings.Colors.main

        sizeLabel.font = ThemeSettings.Fonts.default(size: .subhead)
        sizeLabel.textColor = ThemeSettings.Colors.main
    }

    fileprivate func refresh() {

        guard let dish = self.dish,
                let menu = self.menu else {
                return
        }

        if (dish.type == .simpleDish) {
            priceLabel.setup(price: dish.price, currency: menu.currency)
            sizeLabel.setup(size: dish.size, units: dish.sizeUnits)
            isShowSizeAndPrice = true
        } else if (dish.type == .variation) {

            let variations = menu.variations.filter({ $0.parentDishId == dish.ID })
            if let variation = variations.min(by: { $0.price < $1.price }) {

                priceLabel.setup(price: variation.price, currency: menu.currency)
                sizeLabel.setup(size: variation.size, units: dish.sizeUnits)
                isShowSizeAndPrice = true
            } else {
                isShowSizeAndPrice = false
            }
        } else {
            isShowSizeAndPrice = false
        }
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
