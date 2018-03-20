//
//  DishModalSelectAddings.swift
//  CoreFramework
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class DishModalSelectAddings: UITableViewCell {

    public static func create(for addings: [Adding], from menu: MenuSummary, with delegate: AddDishToCartModalDelegateProtocol) -> DishModalSelectAddings {

        let nibname = String.tag(DishModalSelectAddings.self)
        let cell: DishModalSelectAddings = UINib.instantiate(from: nibname, bundle: Bundle.coreFramework)
        cell.setup(for: addings, from: menu)
        cell.delegate = delegate

        return cell
    }

    //UI
    @IBOutlet private weak var addingsTable: UITableView!
    private var countTableHeight: Bool = false
    private var refreshTrigger: Trigger?

    //Data
    private var addings: [AddingModel] = []
    private var menu: MenuSummary!
    private var delegate: AddDishToCartModalDelegateProtocol?

    public override func awakeFromNib() {
        super.awakeFromNib()

        addingsTable.delegate = self
        addingsTable.dataSource = self
        addingsTable.rowHeight = UITableViewAutomaticDimension
        addingsTable.estimatedRowHeight = 45.0

        DishModalSelectAddingsCell.register(in: addingsTable)
    }

    private func setup(for addings: [Adding], from menu: MenuSummary) {

        let orderedDishes = menu.dishes.ordered
        for adding in addings.ordered {

            if let dishId = adding.addedDishId,
                let dish = orderedDishes.find({ $0.id == dishId }) {
                    self.addings.append(AddingModel(dish))

            } else if let categoryId = adding.addedCategoryId {
                for dish in orderedDishes.filter({ $0.categoryId == categoryId }) {
                    self.addings.append(AddingModel(dish))
                }
            }
        }

        self.menu = menu
        addingsTable.reloadData()
    }
}

extension DishModalSelectAddings: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.add(adding: addings[indexPath.row].dish)
    }
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        delegate?.remove(adding: addings[indexPath.row].dish)
    }
}
extension DishModalSelectAddings: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addings.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: DishModalSelectAddingsCell.identifier, for: indexPath) as! DishModalSelectAddingsCell
        cell.setup(dish: addings[indexPath.row].dish, from: menu)

        return cell
    }
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if (indexPath.row == (addings.count - 1) && !countTableHeight) {
            refreshTrigger?()
            countTableHeight = true
        }
    }
}
extension DishModalSelectAddings: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        return Int(addingsTable.contentSize.height)
    }
    public func addToContainer(handler: @escaping Trigger) {
        self.refreshTrigger = handler
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
fileprivate class AddingModel: ISortable {

    public let dish: Dish
    public var orderNumber: Int {
        return dish.orderNumber
    }

    public init(_ dish: Dish) {
        self.dish = dish
    }
}
