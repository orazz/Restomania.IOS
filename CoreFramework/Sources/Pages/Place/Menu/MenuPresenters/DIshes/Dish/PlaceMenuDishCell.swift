//
//  MenuDishCard.swift
//  CoreFramework
//
//  Created by Алексей on 27.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit

public class PlaceMenuDishCell: UITableViewCell {

    public static let identifier = Guid.new
    public static let height: CGFloat = 105.0

    private static let nibName = String.tag(PlaceMenuDishCell.self)
    private static let nib = UINib(nibName: nibName, bundle: Bundle.coreFramework)
    public static func instance(from dish: ParsedDish) -> PlaceMenuDishCell {

        let cell = nib.instantiate(withOwner: nil, options: nil).first as! PlaceMenuDishCell
        cell.update(by: dish)

        return cell
    }

    //UI elements
    @IBOutlet weak var dishImage: CachedImage!
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishSize: SizeLabel!
    @IBOutlet weak var dishPrice: PriceLabel!

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    //Data
    private var _dish: ParsedDish?

    public override func awakeFromNib() {
        super.awakeFromNib()

        //Name
        dishName.font = themeFonts.bold(size: .subhead)
        dishName.textColor = themeColors.contentText

        //Weight
        dishSize.font = themeFonts.default(size: .caption)
        dishSize.textColor = themeColors.contentText

        //Price
        dishPrice.font = themeFonts.bold(size: .subhead)
        dishPrice.textColor = themeColors.contentText

        backgroundColor = themeColors.contentBackground
    }
    public func update(by dish: ParsedDish) {

        _dish = dish

        dishName.text = dish.name
        dishImage.setup(url: dish.image)

        switch (dish.type) {
            case .simpleDish:
                dishPrice.setup(price: dish.price, currency: dish.currency)
                dishSize.setup(size: dish.size, units: dish.sizeUnits)

            case .variableDish:

                if let minPrice = dish.variation?.minPrice {
                    dishPrice.setup(price: minPrice, currency: dish.currency, useStartFrom: true)
                }
                else {
                    dishPrice.clear()
                }

                if let minSize = dish.variation?.minSize,
                    let minSizeUnits = dish.variation?.minSizeUnits {
                    dishSize.setup(size: minSize, units: minSizeUnits, useStartFrom: true)
                }
                else {
                    dishSize.clear()
                }

            default:
                dishPrice.clear()
                dishSize.clear()
        }

        if (String.isNullOrEmpty(dish.image)) {
            dishImage.setContraint(.width, to: 0)
        } else {
            dishImage.setContraint(.width, to: dishImage.getConstant(.height)!)
        }
    }

}
