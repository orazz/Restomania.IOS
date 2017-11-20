//
//  OrderedDishCell.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 13.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class ManagerOneOrderDishCell: UITableViewCell {

    public static let identifier = "OrderedDishCell-\(Guid.new)"
    private static let nibname = "ManagerOneOrderDishCellView"
    public static let height: CGFloat = 40
    public static func register(for tableView: UITableView) {

        let nib = UINib(nibName: nibname, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }

    //UI Elements
    @IBOutlet weak var NameAndCountLabel: UILabel!
    @IBOutlet weak var CostLabel: PriceLabel!

    //Data
    private var _dish: DishOrderDish!
    private var _currency: CurrencyType!
    private var _IsSetupMarkup: Bool = false

    public func setup(dish: DishOrderDish, currency: CurrencyType) {

        setupStyles()

        _dish = dish
        _currency = currency

        NameAndCountLabel.text = "\(dish.count) x \(dish.name)"
        CostLabel.setup(amount: dish.total.double, currency: currency)
    }
    private func setupStyles() {

        if (_IsSetupMarkup) {

            return
        }

        let font =  ThemeSettings.Fonts.default(size: .subhead)
        NameAndCountLabel.font = font
        CostLabel.font = font

        _IsSetupMarkup = true
    }
}
