//
//  DishModalSelectAddingsCell.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class DishModalSelectAddingsCell: UITableViewCell {

    public static var identifier = Guid.new
    public static var height = CGFloat(45)
    public static func register(in table: UITableView) {

        let nib = UINib(nibName: "\(String.tag(DishModalSelectAddingsCell.self))View", bundle: Bundle.main)
        table.register(nib, forCellReuseIdentifier: identifier)
    }

    //UI
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: PriceLabel!
    @IBOutlet private weak var markImage: UIImageView!

    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    public override func awakeFromNib() {
        super.awakeFromNib()

        let background = UIView()
        background.backgroundColor = themeColors.contentSelection
        background.isOpaque = false
        self.selectedBackgroundView = background

        nameLabel.font = themeFonts.default(size: .head)
        nameLabel.textColor = themeColors.contentBackgroundText

        priceLabel.font = themeFonts.default(size: .subhead)
        priceLabel.textColor = themeColors.contentBackgroundText

        markImage.isHidden = true
    }
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        markImage.isHidden = !selected
    }

    public func setup(dish: Dish, from menu: MenuSummary) {

        nameLabel.text = dish.name
        priceLabel.setup(price: dish.price, currency: menu.currency)
    }
}
