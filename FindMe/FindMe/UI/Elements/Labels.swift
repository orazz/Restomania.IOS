//
//  Labels.swift
//  FindMe
//
//  Created by Алексей on 05.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public class FMTitleLabel: BaseFMLabel {

    public override func initialize() {

        self.font = ThemeSettings.Fonts.bold(size: .title)
        self.textColor = ThemeSettings.Colors.main
    }
}
public class FMHeadlineLabel: BaseFMLabel {

    public override func initialize() {

        self.font = ThemeSettings.Fonts.default(size: .headline)
        self.textColor = ThemeSettings.Colors.main
    }
}
public class FMSubheadLabel: BaseFMLabel {

    public override func initialize() {

        self.font = ThemeSettings.Fonts.default(size: .subhead)
        self.textColor = ThemeSettings.Colors.blackText
    }
}
public class FMCaptionLabel: BaseFMLabel {

    public override func initialize() {

        self.font = ThemeSettings.Fonts.default(size: .caption)
        self.textColor = ThemeSettings.Colors.blackText
    }
}
public class FMSubstringLabel: BaseFMLabel {

    public override func initialize() {

        self.font = ThemeSettings.Fonts.default(size: .substring)
        self.textColor = ThemeSettings.Colors.blackText
    }
}
public class BaseFMLabel: UILabel {

    public override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initialize()
    }
    public func initialize() {

        self.textColor = ThemeSettings.Colors.blackText
    }
}
