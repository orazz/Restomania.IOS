//
//  DishModalSelectPicker.swift
//  CoreFramework
//
//  Created by Алексей on 06.04.2018.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class DishModalSelectPicker: UITableViewCell {
    
    public static func create(with delegate: AddDishToCartModalDelegateProtocol) -> DishModalSelectPicker {

        let nibname = String.tag(DishModalSelectPicker.self)
        let cell: DishModalSelectPicker = UINib.instantiate(from: nibname, bundle: Bundle.coreFramework)
        cell.delegate = delegate

        return cell
    }

    //UI
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var countStepper: UIStepper!

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    //Data
    private var delegate: AddDishToCartModalDelegateProtocol! {
        didSet {
            update()

            countStepper.value = Double(delegate.count)
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.contentBackground

        titleLabel.font = themeFonts.default(size: .subhead)
        titleLabel.textColor = themeColors.contentText
        titleLabel.text = DishModal.Localization.labelsSelectCount.localized

        countLabel.font = themeFonts.bold(size: .title)
        countLabel.textColor = themeColors.contentText
        countLabel.text = "1"
    }

    @IBAction private func changeCount() {
        let value = Int(countStepper.value)

        delegate.count = value
        update()
    }
    private func update() {
        countLabel.text = "\(delegate.count)"
    }
}
extension DishModalSelectPicker: DishModalElementsProtocol {
}
extension DishModalSelectPicker: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        return 140
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
