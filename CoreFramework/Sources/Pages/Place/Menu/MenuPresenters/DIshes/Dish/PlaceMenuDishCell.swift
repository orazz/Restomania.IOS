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
    public static let height: CGFloat = 110.0

    private static let nibName = String.tag(PlaceMenuDishCell.self)
    private static let nib = UINib(nibName: nibName, bundle: Bundle.coreFramework)
    public static func instance(from dish: Dish, with currency: Currency) -> PlaceMenuDishCell {

        let cell = nib.instantiate(withOwner: nil, options: nil).first as! PlaceMenuDishCell
        cell.update(by: dish, with: currency)

        return cell
    }

    //UI elements
    @IBOutlet weak var dishImage: CachedImage!
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishDescription: UILabel!
    @IBOutlet weak var dishWeight: SizeLabel!
    @IBOutlet weak var dishPrice: PriceLabel!

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    //Data
    private var _dish: Dish?

    public override func awakeFromNib() {
        super.awakeFromNib()

        //Name
        dishName.font = themeFonts.bold(size: .subhead)
        dishName.textColor = themeColors.contentText

        //Description
        dishDescription.font = themeFonts.default(size: .caption)
        dishDescription.textColor =  themeColors.contentText

        //Weight
        dishWeight.font = themeFonts.default(size: .caption)
        dishWeight.textColor = themeColors.contentText

        //Price
        dishPrice.font = themeFonts.default(size: .subhead)
        dishPrice.textColor = themeColors.contentText

        backgroundColor = themeColors.contentBackground
    }
    public func update(by dish: Dish, with currency: Currency) {

        _dish = dish

        dishName.text = dish.name
        dishDescription.text = dish.description
        dishImage.setup(url: dish.image)

        dishWeight.setup(size: dish.size, units: dish.sizeUnits)
        switch (dish.type) {
//            case .simpleDish:
//                dishPrice.setup(price: dish.price, currency: currency)
//
//            case .variableDish:
//                guard let menu = delegate.takeMenu(),
//                        let min = menu.variations.filter({ dish.id == $0.parentDishId })
//                                                  .min(by: { $0.price < $1.price }) else {
//                    dishPrice.clear()
//                    break
//                }
//
//                dishPrice.setup(price: min.price, currency: currency, useStartFrom: true)

            default:
                dishPrice.clear()
        }

        if (String.isNullOrEmpty(dish.image)) {
            dishImage.setContraint(.width, to: 0)
        } else {
            dishImage.setContraint(.width, to: dishImage.getConstant(.height)!)
        }
    }

}
