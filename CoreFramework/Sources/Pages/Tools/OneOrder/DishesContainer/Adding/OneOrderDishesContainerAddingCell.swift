//
//  OneOrderDishesContainerAddingCell.swift
//  CoreFramework
//
//  Created by Алексей on 16.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class OneOrderDishesContainerAddingCell: UITableViewCell {

    public static let identifier = Guid.new
    public static func register(for tableView: UITableView) {

        let nib = UINib(nibName: String.tag(OneOrderDishesContainerAddingCell.self), bundle: Bundle.coreFramework)
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    //UI Elements
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costLabel: PriceLabel!

    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    //Data
    private var adding: AdditionSummary!
    private var currency: Currency!

    public override func awakeFromNib() {
        super.awakeFromNib()

        nameLabel.font = themeFonts.default(size: .subcaption)
        nameLabel.textColor = themeColors.contentBackgroundText

        costLabel.font = themeFonts.default(size: .caption)
        costLabel.textColor = themeColors.contentBackgroundText
    }
    public func update(by adding: AdditionSummary, currency: Currency) {

        self.adding = adding
        self.currency = currency

        nameLabel.text = adding.name
        costLabel.setup(amount: adding.cost.double, currency: currency)
    }
}
