//
//  Buttons.swift
//  FindMe
//
//  Created by Алексей on 25.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public class FilledButton: BaseButton {
    
    public override func stylize() {
        super.stylize(text: colors.whiteText, background: colors.main)
    }
}
public class BorderedButton: BaseButton {
    
    public override func stylize() {
        super.stylize(text: colors.main, background: colors.background, border: colors.main)
    }
}

public class BaseButton: UIButton {
    
    internal let colors = ThemeSettings.Colors.self
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        stylize()
    }
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        stylize()
    }
    
    public func stylize() {
        stylize(text: colors.whiteText, background:colors.background)
    }
    public func stylize(text: UIColor, background: UIColor, border: UIColor? = nil) {
        
        //Sizes
        self.titleEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        
        //Styles
        self.titleLabel?.font = ThemeSettings.Fonts.default(size: .headline)
        self.tintColor = text
        self.backgroundColor = background
        
        //border
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = border?.cgColor ?? background.cgColor
    }
}
