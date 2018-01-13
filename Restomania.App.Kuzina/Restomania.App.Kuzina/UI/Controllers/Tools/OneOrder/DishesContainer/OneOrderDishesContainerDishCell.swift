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

public class OneOrderDishesContainerDishCell: UITableViewCell {

    public static let identifier = "OrderedDishCell-\(Guid.new)"
    public static let height: CGFloat = 40
    private static let nibname = "\(String.tag(OneOrderDishesContainerDishCell.self))View"
    public static func register(for tableView: UITableView) {

        let nib = UINib(nibName: nibname, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }

    //UI Elements
    @IBOutlet weak var NameAndCountLabel: UILabel!
    @IBOutlet weak var CostLabel: PriceLabel!

    //Data
    private var dish: DishOrderDish!
    private var currency: CurrencyType!

    public override func awakeFromNib() {
        super.awakeFromNib()

        let font =  ThemeSettings.Fonts.default(size: .subhead)

        NameAndCountLabel.font = font
        CostLabel.font = font
    }
    public func update(dish: DishOrderDish, currency: CurrencyType) {

        self.dish = dish
        self.currency = currency

        NameAndCountLabel.text = "\(dish.count) x \(dish.name)"
        CostLabel.setup(amount: dish.total.double, currency: currency)
    }
}
