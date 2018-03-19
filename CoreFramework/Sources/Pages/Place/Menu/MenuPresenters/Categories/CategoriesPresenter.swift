//
//  CategoriesPresenter.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 16.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

extension PlaceMenuController {
    internal class CategoriesPresenter: NSObject, PlaceMenuElementProtocol {

        public static let commonCategory: Long = -1

        private let categoriesView: UICollectionView

        private let themeColors = DependencyResolver.get(ThemeColors.self)
        private let themeFonts = DependencyResolver.get(ThemeFonts.self)

        public var delegate: PlaceMenuDelegate?
        private var categories: [CategoryContainer]
        private var selectedCategory: Long = CategoriesPresenter.commonCategory

        public init(for collection: UICollectionView, with delegate: PlaceMenuDelegate) {

            self.delegate = delegate
            self.categoriesView = collection
            self.categories = []

            super.init()

            setupCollectionView()
        }
        private func setupCollectionView() {

            PlaceMenuCategoryCell.register(in: categoriesView)

            categoriesView.delegate = self
            categoriesView.dataSource = self
            categoriesView.allowsSelection = true
            categoriesView.allowsMultipleSelection = false
            categoriesView.backgroundColor = themeColors.contentBackground
            let flow = UICollectionViewFlowLayout()
            flow.minimumLineSpacing = 0
            flow.minimumInteritemSpacing = 0
            flow.scrollDirection = .horizontal
            flow.itemSize = CGSize.zero
            categoriesView.collectionViewLayout = flow
        }

        // MARK: Interface
        public func select(category: Long) {

            selectAndNotify(about: category)
            reload()
        }
        public func update(delegate: PlaceMenuDelegate) {

            guard let menu = delegate.takeMenu() else {
                return
            }

            let commonCategory = MenuCategory()
            commonCategory.name = PlaceMenuController.Localization.AllDishesCategory.localized
            commonCategory.id = CategoriesPresenter.commonCategory
            commonCategory.orderNumber = -1

            let allCategories = [ParsedCategory(source: commonCategory, from: menu.source)] + menu.categoriesForShow.filter({ $0.isBase })
            categories = allCategories.map({ CategoryContainer(for: $0) })

            reload()

            if (categories.isFilled) {
                selectedCategory = categories.first!.id
            }
            if let index = categories.index(where: { selectedCategory == $0.id }) {
                let path = IndexPath(item: index, section: 0)
                categoriesView.selectItem(at: path, animated: true, scrollPosition: .centeredHorizontally)
            }
            selectAndNotify(about: selectedCategory)
        }
        private func reload() {
            categoriesView.reloadData()
        }
    }
}
extension PlaceMenuController.CategoriesPresenter: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return categories[indexPath.item].size
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = categories[indexPath.item].cell(for: collectionView, by: indexPath)
        cell.select()

        let category = categories[indexPath.item].category
        selectAndNotify(about: category.id, path: indexPath)
    }
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        let cell = categories[indexPath.item].cell(for: collectionView, by: indexPath)
        cell.deselect()
    }
    private func selectAndNotify(about category: Long, path: IndexPath? = nil) {

        selectedCategory = category
        delegate?.select(category: category)

        if let path = path {
            categoriesView.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
            return
        }

        categoriesView.setContentOffset(CGPoint.zero, animated: true)
    }
}
extension PlaceMenuController.CategoriesPresenter: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let category = categories[indexPath.item]
        let cell = category.cell(for: collectionView, by: indexPath)

        if (category.id == selectedCategory) {
            cell.select()
        }
        else {
            cell.deselect()
        }

        return cell
    }
}
extension PlaceMenuController.CategoriesPresenter {
    fileprivate class CategoryContainer {

        fileprivate let category: ParsedCategory
        private var cell: PlaceMenuCategoryCell?
        private let identifier = PlaceMenuCategoryCell.identifier

        fileprivate init(for category: ParsedCategory) {
            self.category = category
            self.cell = nil
        }

        fileprivate var id: Long {
            return category.id
        }
        fileprivate var size: CGSize {
            return PlaceMenuCategoryCell.size(for: category)
        }
        fileprivate func cell(for collection: UICollectionView, by path: IndexPath) -> PlaceMenuCategoryCell {

            if let cell = cell {
                return cell
            }

            let builded = collection.dequeueReusableCell(withReuseIdentifier: identifier, for: path) as! PlaceMenuCategoryCell
            builded.update(by: category)
            cell = builded

            return builded
        }
    }
}
