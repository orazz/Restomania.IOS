//
//  PlaceCartDishesContainerCellMeta.swift
//  CoreFramework
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

        let nibname = String.tag(PlaceCartDishesContainerCellMeta.self)
        let nib = UINib(nibName: nibname, bundle: Bundle.coreFramework)
        table.register(nib, forCellReuseIdentifier: identifier)
    }

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    //UI
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: PriceLabel!
    

    public override func awakeFromNib() {
        super.awakeFromNib()

        nameLabel.font = themeFonts.default(size: .subcaption)
        nameLabel.textColor = themeColors.contentText

        priceLabel.font = themeFonts.default(size: .subcaption)
        priceLabel.textColor = themeColors.contentText
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
