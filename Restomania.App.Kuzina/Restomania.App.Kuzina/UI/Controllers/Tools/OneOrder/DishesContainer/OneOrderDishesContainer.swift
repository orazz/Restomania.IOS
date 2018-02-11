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

    private static var nibName = "\(String.tag(OneOrderDishesContainer.self))View"
    public static var instance: OneOrderDishesContainer {

        let cell: OneOrderDishesContainer = UINib.instantiate(from: nibName, bundle: Bundle.main)

        return cell
    }

    //UI
    @IBOutlet private weak var dishesTable: UITableView!

    //Data
    private var currency: CurrencyType = CurrencyType.All
    private var dishes: [DishOrderDish] = []

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = ThemeSettings.Colors.additional
        dishesTable.backgroundColor = ThemeSettings.Colors.additional

        OneOrderDishesContainerDishCell.register(for: dishesTable)
    }
}
//Table
extension OneOrderDishesContainer: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OneOrderDishesContainerDishCell.identifier, for: indexPath) as! OneOrderDishesContainerDishCell

        cell.update(dish: dishes[indexPath.row], currency: currency)

        return cell
    }
}
//One order interface
extension OneOrderDishesContainer: OneOrderInterfacePart {
    public func update(by update: DishOrder) {

        currency = update.currency
        dishes = update.dishes

        dishesTable.reloadData()
    }
}
extension OneOrderDishesContainer: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return Int(dishesTable.contentSize.height)
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
