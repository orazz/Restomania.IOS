//
//  DishModalSelectVariationsCell.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class DishModalSelectVariationsCell: UITableViewCell {

    public static var identifier = Guid.new
    public static var height = CGFloat(45.0)
    public static func register(in table: UITableView) {

        let nibname = String.tag(DishModalSelectVariationsCell.self)
        let nib = UINib(nibName: nibname, bundle: Bundle.coreFramework)
        table.register(nib, forCellReuseIdentifier: identifier)
    }

    //UI
    @IBOutlet private weak var sizeLabel: SizeLabel!
    @IBOutlet private weak var priceLabel: PriceLabel!
    @IBOutlet private weak var markImage: UIImageView!

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.contentBackground

        let background = UIView()
        background.backgroundColor = themeColors.contentSelection
        background.isOpaque = false
        self.selectedBackgroundView = background

        sizeLabel.font = themeFonts.default(size: .subhead)
        sizeLabel.textColor = themeColors.contentText

        priceLabel.font = themeFonts.default(size: .subhead)
        priceLabel.textColor = themeColors.contentText

        markImage.isHidden = true
    }
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        markImage.isHidden = !selected
    }
    public func setup(for variation: Variation, with menu: MenuSummary) {
        sizeLabel.setup(size: variation.size, units: variation.sizeUnits)
        priceLabel.setup(price: variation.price, currency: menu.currency)
    }
}
