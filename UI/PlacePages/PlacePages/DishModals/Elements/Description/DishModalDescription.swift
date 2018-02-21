//
//  DishModalDescription.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import CoreDomains

public class DishModalDescription: UITableViewCell {

    public static func create(for dish: BaseDish, with menu: MenuSummary) -> DishModalDescription {
        let cell: DishModalDescription = UINib.instantiate(from: "\(String.tag(DishModalDescription.self))View", bundle: Bundle.main)
        cell.update(by: dish, from: menu)

        return cell
    }

    //UI
    @IBOutlet private var descriptionLabel: UILabel!

    //Data
    private var dish: BaseDish? {
        didSet {
            refresh()
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        descriptionLabel.font = ThemeSettings.Fonts.default(size: .caption)
        descriptionLabel.textColor = ThemeSettings.Colors.main
    }

    private func refresh() {

        guard let dish = self.dish else {
            return
        }

        descriptionLabel.text = dish.description
    }
}
extension DishModalDescription: DishModalElementsProtocol {
    public func update(by dish: BaseDish, from: MenuSummary) {
        self.dish = dish
    }
}
extension DishModalDescription: InterfaceTableCellProtocol {
    public var viewHeight: Int {

        guard let description = dish?.description,
                !String.isNullOrEmpty(description) else {
                return 0
        }

        return Int(description.height(containerWidth: descriptionLabel.frame.width, font: descriptionLabel.font)) + 10
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
