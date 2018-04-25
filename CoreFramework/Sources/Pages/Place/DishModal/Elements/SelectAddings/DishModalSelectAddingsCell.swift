//
//  DishModalSelectAddingsCell.swift
//  CoreFramework
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class DishModalSelectAddingsCell: UITableViewCell {

    public static var identifier = Guid.new
    public static func register(in table: UITableView) {

        let nibname = String.tag(DishModalSelectAddingsCell.self)
        let nib = UINib(nibName: nibname, bundle: Bundle.coreFramework)
        table.register(nib, forCellReuseIdentifier: identifier)
    }

    //UI
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: PriceLabel!
    @IBOutlet private weak var markImage: UIImageView!

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.contentBackground

        let background = UIView()
        background.backgroundColor = UIColor.clear
        background.isOpaque = false
        self.selectedBackgroundView = background

        nameLabel.font = themeFonts.default(size: .subhead)
        nameLabel.textColor = themeColors.contentText

        priceLabel.font = themeFonts.default(size: .subhead)
        priceLabel.textColor = themeColors.contentText

        markImage.isHidden = true
    }
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        markImage.isHidden = !selected
    }

    public func setup(dish: ParsedDish, with currency: Currency) {

        nameLabel.text = dish.name
        priceLabel.setup(price: dish.price, currency: currency)
    }
}
