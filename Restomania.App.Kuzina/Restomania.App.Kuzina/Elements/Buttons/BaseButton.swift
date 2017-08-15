//
//  BaseButton.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit

public  class BaseButton: UIButton {

    internal let theme = AppSummary.current.theme

    public override init(frame: CGRect) {
        super.init(frame: frame)

        stylize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        stylize()
    }

    internal func stylize() {

        stylize(textColor: theme.blackColor, backgroundColor: theme.backgroundColor)
    }
    internal func stylize(textColor: UIColor, backgroundColor: UIColor, borderColor: UIColor? = nil) {

        self.titleLabel?.font = UIFont(name: theme.susanBookFont, size: theme.subheadFontSize)!
        self.titleLabel?.textColor = textColor
        self.backgroundColor = backgroundColor

        //border
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        if let borderColor = borderColor {

            self.layer.borderColor = borderColor.cgColor
        }
    }
}
