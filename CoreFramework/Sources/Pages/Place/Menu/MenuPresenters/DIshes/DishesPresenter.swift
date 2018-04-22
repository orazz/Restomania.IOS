//
//  DishesPresenter.swift
//  CoreFramework
//
//  Created by Алексей on 16.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

extension PlaceMenuController {
    internal class DishesPresenter: NSObject {

        private let table: UITableView
        private var cells: [Long : PlaceMenuDishCell]

        public var delegate: PlaceMenuDelegate?
        private var menu: ParsedMenu?
        public private(set) var selectedCategoryId: Long?
        private var categories: [CategoryContainer]


        internal init(for table: UITableView, with delegate: PlaceMenuDelegate) {

            self.table = table
            self.cells = [Long: PlaceMenuDishCell]()

            self.delegate = delegate
            self.menu = delegate.takeMenu()
            self.selectedCategoryId = nil
            self.categories = []

            super.init()

            setupDishesTable()
        }
        private func setupDishesTable() {

            table.delegate = self
            table.dataSource = self
        }

        public func select(category categoryId: Long?) {

            self.selectedCategoryId = categoryId

            reload()

            DispatchQueue.main.async {
                self.table.setContentOffset(CGPoint.zero, animated: false)
            }
        }
        private func reload() {

            guard let menu = menu else {
                return
            }

            if let selectedCategory = selectedCategoryId {
                self.categories = collectFor(selectedCategory, from: menu)
            } else {
                self.categories = collectAll(from: menu)
            }

            table.reloadData()
        }
        private func collectFor(_ categoryId: Long, from menu: ParsedMenu) -> [CategoryContainer] {

            var result = [CategoryContainer]()

            guard let parent = menu.categoriesForDisplay.find(id: categoryId) else {
                return result
            }

            let categories = ([parent] + parent.child).filter({ $0.isPublic && $0.hasDishes })
            for category in categories  {
                let model = CategoryContainer(source: category, includeChild: false, from: menu)
                result.append(model)
            }

            return result
        }
        private func collectAll(from menu: ParsedMenu) -> [CategoryContainer] {

            var result = [CategoryContainer]()

            for category in menu.categoriesForDisplay  {
                let model = CategoryContainer(source: category, includeChild: true, from: menu)
                result.append(model)
            }

            return result
        }
    }
}
extension PlaceMenuController.DishesPresenter: PlaceMenuElementProtocol {

    public func viewWillAppear() {}
    public func viewDidDisappear() {
        cells.removeAll()
    }
    public func update(delegate: PlaceMenuDelegate) {

        guard let menu = delegate.takeMenu() else {
            return
        }

        self.menu = menu
        reload()
    }
}
extension PlaceMenuController.DishesPresenter: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let dish = categories[indexPath]
        delegate?.select(dish: dish.id)
    }
}
extension PlaceMenuController.DishesPresenter: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        let category = categories[section]
        if selectedCategoryId == category.id {
            return 0.0
        }

        return PlaceMenuSubcategoryHeader.height
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let category = categories[section]
        if selectedCategoryId == category.id {
            return nil
        }

        return PlaceMenuSubcategoryHeader.instance(for: category.name)
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].dishes.count
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PlaceMenuDishCell.height
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let dish = categories[indexPath]
        if let cell = cells[dish.id] {
            cell.update(by: dish)
            return cell
        }

        let cell = PlaceMenuDishCell.instance(from: dish)
        cells[dish.id] = cell

        return cell
    }
}
extension PlaceMenuController.DishesPresenter {
    fileprivate class CategoryContainer: IIdentified {

        public let source: ParsedCategory
        public let dishes: [ParsedDish]

        fileprivate init(source: ParsedCategory, includeChild: Bool, from menu: ParsedMenu) {
            self.source = source

            if (includeChild) {
                self.dishes = menu.publicDishesWithChild(for: source)
            }
            else {
                self.dishes = source.dishes
            }
        }

        public var id: Long {
            return source.id
        }
        public var name: String {
            return source.name
        }
    }
}
extension Array where Element: PlaceMenuController.DishesPresenter.CategoryContainer {
    subscript(path: IndexPath) -> ParsedDish {

        let category = self[path.section]
        let dish = category.dishes[path.row]

        return dish
    }
}
