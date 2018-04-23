//
//  PlaceCartDishRow.swift
//  CoreFramework
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class PlaceCartDishRow: UITableViewCell {

    private static let nibName = String.tag(PlaceCartDishRow.self)
    public static func create(for dish: AddedOrderDish, with cart: CartService, and menu: MenuSummary) -> PlaceCartDishRow {

        let cell: PlaceCartDishRow = UINib.instantiate(from: nibName, bundle: Bundle.coreFramework)
        cell.dish = dish

        if let source = menu.dishes.find({ $0.id == dish.dishId }) {

            if (source.type == .simpleDish) {
                cell.dishName = source.name
            } else if source.type == .variableDish,
                    let variationiId = dish.variationId,
                    let variation = menu.variations.find({ $0.id == variationiId }) {
                cell.dishName = variation.name
            }
        }
        cell.cart = cart
        cell.menu = menu

        cell.refresh()

        return cell
    }

    //UI hooks
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var totalLabel: PriceLabel!
    @IBOutlet private weak var forwardIcon: UIImageView!

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.contentBackground

        titleLabel.font = themeFonts.default(size: .caption)
        titleLabel.textColor = themeColors.contentText

        totalLabel.font = themeFonts.default(size: .subhead)
        totalLabel.textColor = themeColors.contentText
    }

    //Data
    private let _tag = String.tag(PlaceCartDishRow.self)
    private let guid = Guid.new

    public var dish: AddedOrderDish!
    private var dishName: String = String.empty
    private var addings: [Dish] = []
    private var menu: MenuSummary!
    private var cart: CartService!

    private func refresh() {

        titleLabel.text = "\(dish.count) x \(dishName)"
        totalLabel.setup(price: dish.total(with: menu), currency: menu.currency)

        addings = dish.addings.map({ menu.dishes.find(id: $0) })
                                 .filter({ nil != $0 })
                                 .map({ $0! })
    }
}
extension PlaceCartDishRow: PlaceCartElement {
    public func height() -> CGFloat {
        return 50.0
    }
}
