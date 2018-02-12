//
//  DishCategoryCard.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 27.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit

public class PlaceMenuCategoryCell: UICollectionViewCell {

    public static let identifier = "DishCategoryCard-\(Guid.new)"
    private static let nibName = "PlaceMenuCategoryCellView"
    public static func register(in collection: UICollectionView) {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)

        collection.register(nib, forCellWithReuseIdentifier: identifier)
    }

    private static let nameFont = ThemeSettings.Fonts.default(size: .subhead)
    public static func sizeOfCell(category: MenuCategory) -> CGSize {

        let text = category.name as NSString
        let width = text.size(withAttributes: [NSAttributedStringKey.font: PlaceMenuCategoryCell.nameFont]).width + 12 + 12 //12 is offset label from parent cell

        return CGSize(width: width, height: 36)
    }

    //UI elements
    @IBOutlet private weak var name: UILabel!

    //Data & services
    private var _isInitedStyles: Bool = false

    public func update(by category: MenuCategory) {

        setupStyles()

        name.text = category.name.lowercased()
    }
    private func setupStyles() {

        if (_isInitedStyles) {
            return
        }
        _isInitedStyles = true

        name.font = PlaceMenuCategoryCell.nameFont
        deselect()
    }

    // MARK: Methods
    public func select() {

        name.textColor = ThemeSettings.Colors.additional
        backgroundColor = ThemeSettings.Colors.main
    }
    public func deselect() {

        name.textColor = ThemeSettings.Colors.main
        backgroundColor = ThemeSettings.Colors.additional
    }
}
