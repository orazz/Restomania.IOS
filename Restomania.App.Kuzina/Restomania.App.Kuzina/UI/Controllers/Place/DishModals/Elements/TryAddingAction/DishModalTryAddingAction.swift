//
//  DishModalTryAddingAction.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class DishModalTryAddingAction: UIView {

    //UI
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var actionLabel: UILabel!

    //Data
    private var delegate: DishModalDelegateProtocol?

    public override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = ThemeSettings.Colors.main
        Bundle.main.loadNibNamed("\(String.tag(DishModalTryAddingAction.self))View", owner: self, options: nil)

        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.backgroundColor = ThemeSettings.Colors.main
        self.addSubview(contentView)

        actionLabel.font = ThemeSettings.Fonts.default(size: .title)
        actionLabel.textColor = ThemeSettings.Colors.additional
    }

    public func link(with delegate: DishModalDelegateProtocol) {
        self.delegate = delegate
    }

    @IBAction private func tryAddDish() {
        delegate?.tryAddDish()
    }
}
