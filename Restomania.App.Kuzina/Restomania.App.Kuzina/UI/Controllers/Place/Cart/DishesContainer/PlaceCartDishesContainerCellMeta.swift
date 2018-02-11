//
//  PlaceCartDishesContainerCellMeta.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 01.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class PlaceCartDishesContainerCellMeta: UITableViewCell {

    public static var identifier = Guid.new
    public static var height = CGFloat(20)
    public static func register(in table: UITableView) {

        let nib = UINib(nibName: "\(String.tag(PlaceCartDishesContainerCellMeta.self))View", bundle: Bundle.main)
        table.register(nib, forCellReuseIdentifier: identifier)
    }

    //UI
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: PriceLabel!

    public override func awakeFromNib() {
        super.awakeFromNib()

        nameLabel.font = ThemeSettings.Fonts.default(size: .subcaption)
        nameLabel.textColor = ThemeSettings.Colors.main

        priceLabel.font = ThemeSettings.Fonts.default(size: .subcaption)
        priceLabel.textColor = ThemeSettings.Colors.main
    }

    public func setup(dish: Dish, with menu: MenuSummary) {

        nameLabel.text = dish.name

        if (dish.price == Price.zero) {
            priceLabel.clear()
        } else {
            priceLabel.setup(price: dish.price, currency: menu.currency)
        }
    }
}
