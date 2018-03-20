//
//  DishModalHeader.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class DishModalHeader: UITableViewCell {

    public static func create(for dish: ParsedDish) -> DishModalHeader {

        let nibname = String.tag(DishModalHeader.self)
        let cell: DishModalHeader = UINib.instantiate(from: nibname, bundle: Bundle.coreFramework)
        cell.update(by: dish)

        return cell
    }

    //UI
    @IBOutlet private weak var imageContainer: UIView!
    @IBOutlet private weak var imageContainerWidth: NSLayoutConstraint!
    @IBOutlet private weak var imageContainerOffsetLeft: NSLayoutConstraint!
    @IBOutlet private weak var imageWidth: NSLayoutConstraint!
    @IBOutlet private weak var dishImage: CachedImage!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!


    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    //Data
    private var dish: ParsedDish? = nil {
        didSet {
            apply()
        }
    }
    private var delegate: DishModalDelegateProtocol?

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.contentBackground

        dishImage.contentMode = .scaleAspectFit

        nameLabel.font = themeFonts.bold(size: .title)
        nameLabel.textColor = themeColors.contentText
    }
    private func apply() {
        guard let dish = self.dish else {
            return
        }

        let hasImage = !String.isNullOrEmpty(dish.image)

        imageContainer.isHidden = !hasImage
        imageContainerWidth.constant = imageContainerOffsetLeft.constant + (hasImage ? imageWidth.constant : 0.0)
        dishImage.setup(url: dish.image)

        nameLabel.text = dish.name
    }

    @IBAction private func closeModal() {
        delegate?.closeModal()
    }
}
extension DishModalHeader: DishModalElementsProtocol {

    public func link(with delegate: DishModalDelegateProtocol) {
        self.delegate = delegate
    }
    public func update(by dish: ParsedDish) {
        self.dish = dish
    }
}
extension DishModalHeader: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return 160
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
