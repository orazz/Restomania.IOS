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
    public static let identifier = "DishCategoryCard-\(Guid.New)"

    @IBOutlet weak var name: UILabel!

    private static let _nameFont = UIFont(name: AppSummary.current.theme.susanBookFont, size: AppSummary.current.theme.subheadFontSize)
    private let _theme = AppSummary.current.theme
    private var _categoryID: Long!
    private var _handler: ((Long, DishCategoryCard) -> Void)?

    public func setup(category: DishCategory, handler: @escaping (Long, DishCategoryCard) -> Void ) {

        _categoryID = category.ID
        _handler = handler
        name.text = category.Name.lowercased()

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

        name.textColor = _theme.whiteColor
        backgroundColor = _theme.blackColor
    }
    public func unSelect() {

        name.textColor = _theme.blackColor
        backgroundColor = _theme.whiteColor
    }

    public static func sizeOfCell(category: DishCategory) -> CGSize {

        let text = category.Name as NSString
        let width = text.size(attributes: [NSFontAttributeName: DishCategoryCard._nameFont!]).width + 12 + 12 //12 is offset label from parent cell

        return CGSize(width: width, height: 36)
    }
}
