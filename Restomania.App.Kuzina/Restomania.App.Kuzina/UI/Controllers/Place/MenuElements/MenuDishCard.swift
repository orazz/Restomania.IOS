//
//  MenuDishCard.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 27.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import IOSLibrary

public class MenuDishCard: UITableViewCell {

    public static let nibName = "MenuDishCard"
    public static let identifier = "MenuDishCard-\(Guid.new)"
    public static let height = CGFloat(110)
    public static let nib = UINib(nibName: nibName, bundle: Bundle.main)

    public static var newInstance: MenuDishCard {

        return nib.instantiate(withOwner: nil, options: nil).first as! MenuDishCard
    }

    @IBOutlet weak var dishImage: WrappedImage!
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishDescription: UILabel!
    @IBOutlet weak var dishPrice: PriceLabel!
    @IBOutlet weak var addButton: UIImageView!

    private var _dishID: Long!
    private var _dish: Dish!
    private var _currency: CurrencyType!
    private var _handler: ((Long) -> Void)?

    public func setup(dish: Dish, currency: CurrencyType, handler: @escaping ((Long) -> Void)) {

        _dishID = dish.ID
        _dish = dish
        _currency = currency
        _handler = handler

        setupStyles()
    }
    private func setupStyles() {

        //Name
        dishName.font = ThemeSettings.Fonts.bold(size: .title)
        dishName.text = _dish.name
        dishName.textColor = ThemeSettings.Colors.main

        //Description
        dishDescription.font = ThemeSettings.Fonts.default(size: .caption)
        dishDescription.text = _dish.description
        dishDescription.textColor = ThemeSettings.Colors.main

        //Price
        dishPrice.font = ThemeSettings.Fonts.default(size: .subhead)
        dishPrice.textColor = ThemeSettings.Colors.main
        dishPrice.setup(amount: _dish.price.double, currency: _currency)

        //Image
        dishImage.setup(url: _dish.image)

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction))
        addButton.addGestureRecognizer(tap)
        addButton.isUserInteractionEnabled = true
    }
    @objc private func tapAction() {

        if let handler = _handler {
            handler(_dishID)
        }
    }
}
