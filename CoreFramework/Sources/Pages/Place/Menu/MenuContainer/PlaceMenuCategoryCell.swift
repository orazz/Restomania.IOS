//
//  DishCategoryCard.swift
//  Kuzina
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

    private static let nameFont = DependencyResolver.resolve(ThemeFonts.self).default(size: .subhead)
    public static func sizeOfCell(category: MenuCategory) -> CGSize {

        let text = category.name as NSString
        let width = text.size(withAttributes: [NSAttributedStringKey.font: nameFont]).width + 12 + 12 //12 is offset label from parent cell

        return CGSize(width: width, height: 36)
    }

    //UI elements
    @IBOutlet private weak var name: UILabel!

    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    //Data & services
    public override func awakeFromNib() {
        super.awakeFromNib()

        name.font = PlaceMenuCategoryCell.nameFont
        deselect()
    }

    public func update(by category: MenuCategory) {
        name.text = category.name.lowercased()
    }

    // MARK: Methods
    public func select() {

        name.textColor = themeColors.actionContent
        backgroundColor = themeColors.actionMain
    }
    public func deselect() {

        name.textColor = themeColors.contentBackgroundText
        backgroundColor = themeColors.contentBackground
    }
}

