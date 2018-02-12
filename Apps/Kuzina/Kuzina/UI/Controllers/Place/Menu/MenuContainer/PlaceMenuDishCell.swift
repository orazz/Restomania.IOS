//
//  MenuDishCard.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 27.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit

public class PlaceMenuDishCell: UITableViewCell {

    public static let identifier = "\(String.tag(PlaceMenuDishCell.self))-\(Guid.new)"
    public static let height = CGFloat(110)

    private static let nibName = "\(String.tag(PlaceMenuDishCell.self))View"
    private static let nib = UINib(nibName: nibName, bundle: Bundle.main)
    public static func instance(for dish: Dish, with currency: CurrencyType, delegate: PlaceMenuDelegate) -> PlaceMenuDishCell {

        let cell = nib.instantiate(withOwner: nil, options: nil).first as! PlaceMenuDishCell
        cell.setupStyles()

        cell.update(by: dish, with: currency, delegate: delegate)

        return cell
    }

    //UI elements
    @IBOutlet weak var dishImage: CachedImage!
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishDescription: UILabel!
    @IBOutlet weak var dishWeight: SizeLabel!
    @IBOutlet weak var dishPrice: PriceLabel!

    //Data
    private var _dish: Dish?
    private var _delegate: PlaceMenuDelegate?

    public func update(by dish: Dish, with currency: CurrencyType, delegate: PlaceMenuDelegate) {

        _dish = dish
        _delegate = delegate

        dishName.text = dish.name
        dishDescription.text = dish.description
        dishImage.setup(url: dish.image)

        dishWeight.setup(size: dish.size, units: dish.sizeUnits)
        switch (dish.type) {
            case .simpleDish:
                dishPrice.setup(price: dish.price, currency: currency)

            case .variableDish:
                guard let menu = delegate.takeMenu(),
                        let min = menu.variations.filter({ dish.ID == $0.parentDishId })
                                                  .min(by: { $0.price < $1.price }) else {
                    dishPrice.clear()
                    break
                }

                dishPrice.setup(price: min.price, currency: currency, useStartFrom: true)

            default:
                dishPrice.clear()
        }

        if (String.isNullOrEmpty(dish.image)) {
            dishImage.setContraint(.width, to: 0)
        } else {
            dishImage.setContraint(.width, to: dishImage.getConstant(.height)!)
        }
    }

    private func setupStyles() {

        //Name
        dishName.font = ThemeSettings.Fonts.bold(size: .subhead)
        dishName.textColor = ThemeSettings.Colors.main

        //Description
        dishDescription.font = ThemeSettings.Fonts.default(size: .caption)
        dishDescription.textColor = ThemeSettings.Colors.main

        //Weight
        dishWeight.font = ThemeSettings.Fonts.default(size: .caption)
        dishWeight.textColor = ThemeSettings.Colors.main

        //Price
        dishPrice.font = ThemeSettings.Fonts.default(size: .subhead)
        dishPrice.textColor = ThemeSettings.Colors.main
    }

    @IBAction private func addDish() {

        if let dish = _dish,
            let delegate = _delegate {

            delegate.tryAdd(dish.ID)
        }
    }
}
