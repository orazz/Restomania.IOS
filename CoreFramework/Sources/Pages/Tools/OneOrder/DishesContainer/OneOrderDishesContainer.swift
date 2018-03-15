//
//  OneOrderDishesContainer.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 13.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class OneOrderDishesContainer: UITableViewCell {

    public static var instance: OneOrderDishesContainer {
        return UINib.instantiate(from: String.tag(OneOrderDishesContainer.self), bundle: Bundle.coreFramework)
    }

    //UI
    @IBOutlet private weak var table: UITableView!

    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    //Data
    private var currency: Currency = Currency.All
    private var dishesAndAddings: [UITableViewCell] = []
    private var dishes: [DishOrderDish] = []

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.contentBackground
        table.backgroundColor = themeColors.contentBackground

        OneOrderDishesContainerDishCell.register(for: table)
        OneOrderDishesContainerAddingCell.register(for: table)
    }
}
//Table
extension OneOrderDishesContainer: UITableViewDelegate {
}
extension OneOrderDishesContainer: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishesAndAddings.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dishesAndAddings[indexPath.row]
    }
}
//One order interface
extension OneOrderDishesContainer: OneOrderInterfacePart {
    public func update(by update: DishOrder) {

        currency = update.currency
        dishes = update.dishes

        dishesAndAddings.removeAll()

        for dish in dishes {

            let dishCell = table.dequeueReusableCell(withIdentifier: OneOrderDishesContainerDishCell.identifier) as! OneOrderDishesContainerDishCell
            dishCell.update(by: dish, currency: currency)
            dishesAndAddings.append(dishCell)

            for adding in dish.addings {
                let addingCell = table.dequeueReusableCell(withIdentifier: OneOrderDishesContainerAddingCell.identifier) as! OneOrderDishesContainerAddingCell
                addingCell.update(by: adding, currency: currency)
                dishesAndAddings.append(addingCell)
            }
        }

        table.reloadData()
    }
}
extension OneOrderDishesContainer: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        var height: CGFloat = 0.0
        for (index, _) in dishesAndAddings.enumerated() {
            height += table.rectForRow(at: IndexPath(row: index, section: 0)).height
        }

        return Int(height)
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
