//
//  DishCategoryCard.swift
//  CoreFramework
//
//  Created by Алексей on 27.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit

public class PlaceMenuCategoryCell: UICollectionViewCell {

    public static let identifier = Guid.new
    public static func register(in collection: UICollectionView) {

        let nib = UINib(nibName: String.tag(PlaceMenuCategoryCell.self), bundle: Bundle.coreFramework)
        collection.register(nib, forCellWithReuseIdentifier: identifier)
    }
    private static let defaultFont = DependencyResolver.get(ThemeFonts.self).default(size: .subhead)
    internal static func size(for category: ParsedCategory) -> CGSize {

        let height: CGFloat = 45.0
        let width = category.name.width(containerHeight: 1000.0, font: defaultFont) + 10.0 + 10.0
        return CGSize(width: max(width, 75), height: height)
    }

    //UI elements
    @IBOutlet private weak var name: UILabel!
    public var size: CGSize = CGSize.zero

    private let themeColors = DependencyResolver.get(ThemeColors.self)

    //Data & services
    public override func awakeFromNib() {
        super.awakeFromNib()

        name.font = PlaceMenuCategoryCell.defaultFont
        name.textColor = themeColors.contentText

        deselect()
    }

    public func update(by category: ParsedCategory) {
        name.text = category.name.lowercased()
    }

    // MARK: Methods
    public func select() {
        backgroundColor = themeColors.contentSelection
    }
    public func deselect() {
        backgroundColor = themeColors.contentBackground
    }
}

