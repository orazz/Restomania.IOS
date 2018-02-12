//
//  BaseButton.swift
//  Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit

public  class BaseButton: UIButton {

    public override init(frame: CGRect) {
        super.init(frame: frame)

        stylize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        stylize()
    }

    internal func stylize() {

        stylize(textColor: ThemeSettings.Colors.main, backgroundColor: ThemeSettings.Colors.background)
    }
    internal func stylize(textColor: UIColor, backgroundColor: UIColor, borderColor: UIColor? = nil) {

        //Sizes
//        self.titleEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)

        //Styles
        self.titleLabel?.font = ThemeSettings.Fonts.default(size: .subhead)
        self.tintColor = textColor
        self.backgroundColor = backgroundColor

        //border
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor?.cgColor ?? backgroundColor.cgColor
    }
}
