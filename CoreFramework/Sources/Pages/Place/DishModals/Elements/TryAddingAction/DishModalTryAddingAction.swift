//
//  DishModalTryAddingAction.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class DishModalTryAddingAction: UIView {

    //UI
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var actionLabel: UILabel!

    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    //Data
    private var delegate: DishModalDelegateProtocol?

    public override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = themeColors.actionMain
        Bundle.coreFramework.loadNibNamed("\(String.tag(DishModalTryAddingAction.self))View", owner: self, options: nil)

        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.backgroundColor = themeColors.actionMain
        self.addSubview(contentView)

        actionLabel.font = themeFonts.default(size: .title)
        actionLabel.textColor = themeColors.actionContent
        actionLabel.text = DishModal.Localization.buttonsTryAddDish.localized
    }

    public func link(with delegate: DishModalDelegateProtocol) {
        self.delegate = delegate
    }

    @IBAction private func tryAddDish() {
        delegate?.addToCart()
    }
}
