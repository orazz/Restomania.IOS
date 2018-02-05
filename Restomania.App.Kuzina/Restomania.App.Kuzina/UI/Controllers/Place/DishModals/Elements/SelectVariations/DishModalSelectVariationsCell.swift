//
//  DishModalSelectVariationsCell.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class DishModalSelectVariationsCell: UITableViewCell {

    public static var identifier = Guid.new
    public static var height = CGFloat(45.0)
    public static func register(in table: UITableView) {

        let nib = UINib(nibName: "\(String.tag(DishModalSelectVariationsCell.self))View", bundle: Bundle.main)
        table.register(nib, forCellReuseIdentifier: identifier)
    }

    //UI
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: PriceLabel!
    @IBOutlet private weak var markImage: UIImageView!

    public override func awakeFromNib() {
        super.awakeFromNib()

        let background = UIView()
        background.backgroundColor = ThemeSettings.Colors.background.withAlphaComponent(0.55)
        background.isOpaque = false
        self.selectedBackgroundView = background

        nameLabel.font = ThemeSettings.Fonts.default(size: .head)
        nameLabel.textColor = ThemeSettings.Colors.main

        priceLabel.font = ThemeSettings.Fonts.default(size: .subhead)
        priceLabel.textColor = ThemeSettings.Colors.main

        markImage.isHidden = true
    }
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        markImage.isHidden = !selected
    }
    public func setup(for variation: Variation, with menu: MenuSummary) {
        nameLabel.text = variation.name
        priceLabel.setup(price: variation.price, currency: menu.currency)
    }
}
