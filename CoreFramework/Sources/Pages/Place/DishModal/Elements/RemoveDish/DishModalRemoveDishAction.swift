
//
//  DishModalRemoveDishAction.swift
//  CoreFramework
//
//  Created by Алексей on 24.04.2018.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class DishModalRemoveDishAction: UITableViewCell {

    public static func create(with delegate: DishModalDelegate) -> DishModalRemoveDishAction {

        let nibname = String.tag(DishModalRemoveDishAction.self)
        let cell: DishModalRemoveDishAction = UINib.instantiate(from: nibname, bundle: Bundle.coreFramework)
        cell.delegate = delegate

        return cell
    }

    //UI
    @IBOutlet private weak var titleLabel: UILabel!

    //Service
    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    //Data
    private var delegate: DishModalDelegate?

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.divider

        titleLabel.font = themeFonts.default(size: .head)
        titleLabel.textColor = themeColors.actionMain
        titleLabel.text = DishModal.Localization.buttonsRemoveDish.localized
    }
    @IBAction private func removeDish() {
        delegate?.removeDishFromCart()
    }
}
extension DishModalRemoveDishAction: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        return 60
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
