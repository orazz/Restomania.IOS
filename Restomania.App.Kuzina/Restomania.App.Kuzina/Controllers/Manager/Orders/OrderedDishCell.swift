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

public class OrderedDishCell: UITableViewCell {

    public static let identifier = "OrderedDishCell-\(Guid.New)"
    public static let nibname = "OrderedDishCellView"
    public static let height: CGFloat = 40

    public static func register(for tableView: UITableView) {

        let nib = UINib(nibName: nibname, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }

    //UI Elements
    @IBOutlet weak var NameAndCountLabel: UILabel!
    @IBOutlet weak var CostLabel: PriceLabel!

    //Data
    private var _dish: OrderedDish!
    private var _currency: CurrencyType!
    private var _IsSetupMarkup: Bool = false

    public func setup(dish: OrderedDish, currency: CurrencyType) {

        setupStyles()

        _dish = dish
        _currency = currency

        NameAndCountLabel.text = "\(_dish.Count) x \(_dish.Name)"
        CostLabel.setup(amount: _dish.Cost, currency: _currency)
    }
    private func setupStyles() {

        if (_IsSetupMarkup) {

            return
        }

        let theme = AppSummary.current.theme
        let font = UIFont(name: theme.susanBookFont, size: theme.subheadFontSize)

        NameAndCountLabel.font = font
        CostLabel.font = font

        _IsSetupMarkup = true
    }
}
