//
//  OrderedDishCell.swift
//  CoreFramework
//
//  Created by Алексей on 13.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class OneOrderDishesContainerDishCell: UITableViewCell {

    public static let identifier = Guid.new
    public static func register(for tableView: UITableView) {

        let nib = UINib(nibName: String.tag(OneOrderDishesContainerDishCell.self), bundle: Bundle.coreFramework)
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }

    //UI Elements
    @IBOutlet weak var nameAndCountLabel: UILabel!
    @IBOutlet weak var costLabel: PriceLabel!

    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    //Data
    private var dish: DishOrderDish!
    private var currency: Currency!

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.contentBackground

        nameAndCountLabel.font = themeFonts.default(size: .caption)
        nameAndCountLabel.textColor = themeColors.contentBackgroundText

        costLabel.font = themeFonts.default(size: .subhead)
        costLabel.textColor = themeColors.contentBackgroundText
    }
    public func update(by dish: DishOrderDish, currency: Currency) {

        self.dish = dish
        self.currency = currency

        nameAndCountLabel.text = "\(dish.count) x \(dish.name)"
        costLabel.setup(amount: dish.total.double, currency: currency)
    }
}
