//
//  DishCategoryCard.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 27.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import IOSLibrary

public class DishCategoryCard: UICollectionViewCell {

    public static let nibName = "DishCategoryCard"
    public static let identifier = "DishCategoryCard-\(Guid.new)"

    @IBOutlet weak var name: UILabel!

    private static let _nameFont = ThemeSettings.Fonts.default(size: .subhead)
    private var _categoryID: Long!
    private var _handler: ((Long, DishCategoryCard) -> Void)?

    public func setup(category: MenuCategory, handler: @escaping (Long, DishCategoryCard) -> Void ) {

        _categoryID = category.ID
        _handler = handler
        name.text = category.name.lowercased()

        setupStyles()
    }
    private func setupStyles() {

        //label
        name.font = DishCategoryCard._nameFont
        unSelect()

        //self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction))
        addGestureRecognizer(tap)
    }
    @objc private func tapAction() {

        if let handler = _handler {
            handler(_categoryID, self)
        }
    }

    public func select() {

        name.textColor = ThemeSettings.Colors.additional
        backgroundColor = ThemeSettings.Colors.main
    }
    public func unSelect() {

        name.textColor = ThemeSettings.Colors.main
        backgroundColor = ThemeSettings.Colors.additional
    }

    public static func sizeOfCell(category: MenuCategory) -> CGSize {

        let text = category.name as NSString
        let width = text.size(withAttributes: [NSAttributedStringKey.font: DishCategoryCard._nameFont]).width + 12 + 12 //12 is offset label from parent cell

        return CGSize(width: width, height: 36)
    }
}
