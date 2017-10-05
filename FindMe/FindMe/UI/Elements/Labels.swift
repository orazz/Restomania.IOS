//
//  Labels.swift
//  FindMe
//
//  Created by Алексей on 05.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public class FMTitleLabel: UILabel {

    public override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initialize()
    }
    private func initialize() {

        self.font = ThemeSettings.Fonts.default(size: .title)
        self.tintColor = ThemeSettings.Colors.main
    }
}
