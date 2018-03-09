//
//  PlaceMenuMenuContainer+DIshes.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 16.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import CoreDomains

extension PlaceMenuMenuContainer {
    internal class DishesAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {

        private let table: UITableView
        private var cells: [Long : PlaceMenuDishCell]

        private var menu: MenuSummary
        private var categories: [CategoryContainer]
        private var selectedCategoryId: Long?

        private let delegate: PlaceMenuDelegate

        public init(for table: UITableView, with delegate: PlaceMenuDelegate) {

            self.table = table
            cells = [Long: PlaceMenuDishCell]()

            menu = MenuSummary()
            categories = [CategoryContainer]()
            selectedCategoryId = nil

            self.delegate = delegate

            super.init()

            table.delegate = self
            table.dataSource = self
        }

        // MARK: Interface
        public func update(by menu: MenuSummary) {

            self.menu = menu

            reload()
        }
        public func select(by categoryId: Long?) {

            self.selectedCategoryId = categoryId
            reload()
        }
        public func reload() {

            if let selectedCategory = selectedCategoryId {
                self.categories = collectFor(selectedCategory)
            } else {
                self.categories = collectAll()
            }

            table.reloadData()
            table.setContentOffset(CGPoint.zero, animated: true)
        }
        private func collectAll() -> [CategoryContainer] {

            var result = [CategoryContainer]()
            let alldishes = menu.dishes.ordered
            result.append(CategoryContainer(alldishes.filter({ $0.categoryId == nil })))

            let publicCategories = menu.categories.filter({ !$0.isHidden }).ordered
            let parents = publicCategories.filter({ $0.isBase })
            for category in parents {

                var dishes = [Dish]()
                for dish in alldishes.filter({ $0.categoryId == category.id }) {
                    dishes.append(dish)
                }

                for dependent in publicCategories.filter({ $0.parentId == category.id }) {
                    for dish in alldishes.filter({ $0.categoryId == dependent.id }) {
                        dishes.append(dish)
                    }
                }

                result.append(CategoryContainer(from: category, dishes: dishes))
            }

            return result
        }
        private func collectFor(_ categoryId: Long) -> [CategoryContainer] {

            let filtered = menu.categories.filter({ !$0.isHidden })
                .filter({ $0.id == categoryId || $0.parentId == categoryId })
                .ordered

            var categories = [CategoryContainer]()
            for category in filtered {

                let dishes = menu.dishes.filter({ $0.categoryId == category.id }).ordered
                if (dishes.isEmpty) {
                    continue
                } else {
                    if (category.isBase) {
                        categories.append(CategoryContainer(dishes))
                    } else {
                        categories.append(CategoryContainer(from: category, dishes: dishes))
                    }
                }

            }

            return categories
        }
        public func clear() {
            cells.removeAll()
        }

        // MARK: UITableViewDataSource
        public func numberOfSections(in tableView: UITableView) -> Int {
            return categories.count
        }
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return categories[section].dishes.count
        }
        public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

            guard let _ = categories[section].name else {
                return CGFloat(0)
            }

            return PlaceMenuSubcategoryHeader.height
        }
        public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

            guard let name = categories[section].name else {
                return nil
            }

            return PlaceMenuSubcategoryHeader.instance(for: name)
        }
        public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return PlaceMenuDishCell.height
        }
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let category = categories[indexPath.section]
            let dish = category.dishes[indexPath.row]
            if let cell = cells[dish.id] {
                cell.update(by: dish, with: menu.currency, delegate: delegate)
            } else {
                cells[dish.id] = PlaceMenuDishCell.instance(for: dish, with: menu.currency, delegate: delegate)
            }

            return cells[dish.id]!
        }

        // MARK: UITableViewDelegate
        public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            tableView.deselectRow(at: indexPath, animated: true)

            let category = categories[indexPath.section]
            let dish = category.dishes[indexPath.row]
            delegate.select(dish: dish.id)
        }

        // MARK: UIScrroolViewDelegate
        public func scrollViewDidScroll(_ scrollView: UIScrollView) {
            delegate.scrollTo(offset: scrollView.contentOffset.y )
        }

        private class CategoryContainer {

            public var name: String?
            public var dishes: [Dish]

            public convenience init(from category: MenuCategory, dishes: [Dish]) {

                self.init(dishes)
                self.name = category.name
            }
            public init(_ dishes: [Dish]) {
                self.name = nil
                self.dishes = dishes
            }
        }
    }
}
