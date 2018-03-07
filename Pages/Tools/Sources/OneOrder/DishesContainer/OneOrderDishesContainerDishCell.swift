//
//  OrderedDishCell.swift
//  Kuzina
//
//  Created by Алексей on 13.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import CoreTools
import CoreDomains
import UITools
import UIElements

public class OneOrderDishesContainerDishCell: UITableViewCell {

    public static let identifier = "OrderedDishCell-\(Guid.new)"
    public static let height: CGFloat = 40
    private static let nibname = "\(String.tag(OneOrderDishesContainerDishCell.self))View"
    public static func register(for tableView: UITableView) {

        let nib = UINib(nibName: nibname, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }

    //UI Elements
    @IBOutlet weak var nameAndCountLabel: UILabel!
    @IBOutlet weak var costLabel: PriceLabel!

    private let colorsTheme = DependencyResolver.resolve(ThemeColors.self)
    private let fontsTheme = DependencyResolver.resolve(ThemeFonts.self)

    //Data
    private var dish: DishOrderDish!
    private var currency: Currency!

    public override func awakeFromNib() {
        super.awakeFromNib()

        let font =  fontsTheme.default(size: .subhead)

        nameAndCountLabel.font = font
        nameAndCountLabel.textColor = colorsTheme.contentBackgroundText

        costLabel.font = font
        costLabel.textColor = colorsTheme.contentBackgroundText
    }
    public func update(dish: DishOrderDish, currency: Currency) {

        self.dish = dish
        self.currency = currency

        nameAndCountLabel.text = "\(dish.count) x \(dish.name)"
        costLabel.setup(amount: dish.total.double, currency: currency)
    }
}
