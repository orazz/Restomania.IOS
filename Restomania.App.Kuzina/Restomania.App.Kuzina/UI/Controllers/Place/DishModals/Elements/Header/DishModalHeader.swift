//
//  DishModalHeader.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

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
    @IBOutlet private weak var dishImage: ImageWrapper!
    @IBOutlet private weak var nameContainerView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var imageCloseButton: UIButton!
    @IBOutlet private weak var nameCloseButton: UIButton!

    //Data
    private var dish: BaseDish? = nil {
        didSet {
            apply()
        }
    }
    private var delegate: DishModalDelegateProtocol?

    public override func awakeFromNib() {
        super.awakeFromNib()

        nameLabel.font = ThemeSettings.Fonts.bold(size: .title)
        nameLabel.textColor = ThemeSettings.Colors.main
    }
    private func apply() {
        guard let dish = self.dish else {
            return
        }

        let hasImage = !String.isNullOrEmpty(dish.image)
        
        imageContainerHeight?.constant = hasImage ? 150.0 : 0.0
        dishImage.setup(url: dish.image)

        imageCloseButton.isHidden = !hasImage
        nameCloseButton.isHidden = hasImage

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
        return Int(nameContainerView.frame.height + (imageContainerHeight?.constant ?? 0.0))
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
