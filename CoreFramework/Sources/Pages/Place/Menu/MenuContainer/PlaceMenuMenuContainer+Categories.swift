//
//  PlaceMenuMenuContainer+Categories.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 16.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

extension PlaceMenuMenuContainer {
    internal class CategoriesAdapter: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

        private let collection: UICollectionView
        private let delegate: PlaceMenuDelegate
        private var categories: [MenuCategory]
        private var selectedCategory: Long = -1

        public init(for collection: UICollectionView, with delegate: PlaceMenuDelegate) {

            self.collection = collection
            self.delegate = delegate
            self.categories = [MenuCategory]()

            super.init()

            collection.delegate = self
            collection.dataSource = self
            collection.allowsSelection = true
            collection.allowsMultipleSelection = false

            PlaceMenuCategoryCell.register(in: collection)
        }

        // MARK: Interface
        public func select(category: Long) {

            selectAndNotify(about: category)
            reload()
        }
        public func update(by menu: MenuSummary) {

            var categoriesForShow = [MenuCategory]()
            let notHidden = menu.categories.filter({ !$0.isHidden })
            let filtered = notHidden.filter({ $0.isBase }).ordered
            for category in filtered {

                if (menu.dishes.any({ $0.categoryId == category.id })) {
                    categoriesForShow.append(category)
                } else {
                    let dependents = notHidden.filter({ $0.parentId == category.id })
                    if (dependents.isEmpty) {
                        continue
                    }

                    for dependent in dependents {
                        if (menu.dishes.any({ $0.categoryId == dependent.id })) {
                            categoriesForShow.append(category)
                            break
                        }
                    }
                }
            }

            let allCategory = MenuCategory()
            allCategory.name = PlaceMenuController.Keys.AllDishesCategory.localized
            allCategory.id = -1
            allCategory.orderNumber = -1

            categories = [allCategory] + categoriesForShow

            if (!categories.isEmpty) {
                selectedCategory = categories.first!.id
            }
            selectAndNotify(about: selectedCategory)
            reload()
        }
        private func reload() {
            collection.reloadData()
        }

        // MARK: UICollectionViewDataSource
        public func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return categories.count
        }
        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let category = categories[indexPath.row]
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: PlaceMenuCategoryCell.identifier, for: indexPath) as! PlaceMenuCategoryCell
            cell.update(by: category)

            if (selectedCategory == category.id) {
                cell.select()
            } else {
                cell.deselect()
            }

            return cell
        }

        // MARK: UICollectionViewDelegateFlowLayout
        public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            return PlaceMenuCategoryCell.sizeOfCell(category: categories[indexPath.row])
        }
        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

            for cell in collection.visibleCells {
                if let cell = cell as? PlaceMenuCategoryCell {
                    cell.deselect()
                }
            }

            let cell = collectionView.cellForItem(at: indexPath) as! PlaceMenuCategoryCell
            cell.select()

            let category = categories[indexPath.row]
            selectAndNotify(about: category.id)
        }
        private func selectAndNotify(about category: Long) {

            selectedCategory = category
            delegate.select(category: category)

            if (!collection.visibleCells.isEmpty) {
                let index = categories.index(where: { $0.id == category }) ?? 0
                collection.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
}
