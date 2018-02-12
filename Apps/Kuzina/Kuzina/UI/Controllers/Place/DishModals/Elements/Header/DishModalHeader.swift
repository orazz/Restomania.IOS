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

    private static let nibName = "\(String.tag(DishModalHeader.self))View"
    public static func create(for dish: BaseDish, from menu: MenuSummary) -> DishModalHeader {

        let cell: DishModalHeader = UINib.instantiate(from: nibName, bundle: Bundle.main)
        cell.update(by: dish, from: menu)

        return cell
    }

    //UI
    @IBOutlet private weak var imageContainerView: UIView!
    private var imageContainerHeight: NSLayoutConstraint?
    @IBOutlet private weak var dishImage: CachedImage!
    @IBOutlet private weak var nameContainerView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!

    //Data
    private var dish: BaseDish? = nil {
        didSet {
            apply()
        }
    }
    private var delegate: DishModalDelegateProtocol?

    public override func awakeFromNib() {
        super.awakeFromNib()

        for constraint in imageContainerView.constraints {
            if (constraint.identifier == "ImageHeight") {
                imageContainerHeight = constraint
                break
            }
        }

        self.backgroundColor = ThemeSettings.Colors.additional
        imageContainerView.backgroundColor = ThemeSettings.Colors.additional
        nameContainerView.backgroundColor = ThemeSettings.Colors.additional

        dishImage.contentMode = .scaleAspectFit

        nameLabel.font = ThemeSettings.Fonts.bold(size: .title)
        nameLabel.textColor = ThemeSettings.Colors.main
    }
    private func apply() {
        guard let dish = self.dish else {
            return
        }

        let hasImage = !String.isNullOrEmpty(dish.image)

        imageContainerView.isHidden = !hasImage
        imageContainerHeight?.constant = 20.0 + (hasImage ? 150.0 : 0.0)
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
    public func update(by dish: BaseDish, from: MenuSummary) {
        self.dish = dish
    }
}
extension DishModalHeader: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return Int(nameContainerView.frame.height + imageContainerHeight!.constant)
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
