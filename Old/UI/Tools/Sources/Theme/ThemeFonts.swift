//
//  ThemeFonts.swift
//  UITools
//
//  Created by Алексей on 22.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public enum ThemeFontsSize: Int {
    case title = 22
    case head = 19
    case subhead = 17
    case caption = 14
    case subcaption = 12
}
public protocol ThemeFonts {

    func `default`(size: Int) -> UIFont
    func bold(size: Int) -> UIFont
    
    func icons(size: CGFloat) -> UIFont
}
extension ThemeFonts {

    public func `default`(size: ThemeFontsSize) -> UIFont {
        return self.default(size: size.rawValue)
    }
    public func `default`(size: Int) -> UIFont {
        return UIFont(name: "HelveticaNeue", size: CGFloat(size))!
    }

    public func bold(size: ThemeFontsSize) -> UIFont {
        return self.bold(size: size.rawValue)
    }
    public func bold(size: Int) -> UIFont {
        return UIFont(name: "HelveticaNeue-Bold", size: CGFloat(size))!
    }

    public func icons(size: ThemeFontsSize) -> UIFont {
        return self.icons(size: size.rawValue)
    }
    public func icons(size: Int) -> UIFont {
        return self.icons(size: CGFloat(size))
    }
    public func icons(size: CGFloat) -> UIFont {
        return UIFont(name: "FontAwesome", size: size)!
    }
}
