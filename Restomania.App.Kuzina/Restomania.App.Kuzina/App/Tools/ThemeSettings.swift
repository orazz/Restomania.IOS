//
//  Theme.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 21.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import IOSLibrary

public class ThemeSettings {

    public class Colors {

        public static let main = UIColor(red: 34, green: 31, blue: 30)
        public static let additional = UIColor(red: 255, green: 255, blue: 255)
        public static let grey = UIColor(red: 234, green: 234, blue: 234)
        public static let border = UIColor(red: 165, green: 165, blue: 165)
        public static let background = UIColor(red: 234, green: 234, blue: 234)
    }

    public class Images {

        public static let bottomGradient = loadAssert(named: "bottom-gradient")
        public static let darkFilter = loadAssert(named: "dark-filter")
        public static let `default` = loadAssert(named: "default-image")
        public static let logoDark = loadAssert(named: "logo-dark")
        public static let navigationBackward = loadAssert(named: "nav-back")
        public static let iconInfo = loadAssert(named: "icon-info")

        private static func loadAssert(named: String) -> UIImage {
            return UIImage(named: named, in: Bundle.main, compatibleWith: nil)!
        }
    }

    public class Fonts {

        public enum FontSize: Int {
            case title = 20
            case head = 17
            case subhead = 15
            case caption = 12
            case subcaption = 10
        }

        private static let defaultFont = "HelveticaNeue"
        private static let boldFont = "HelveticaNeue-Bold"
        private static let iconsFont = "FontAwesome"

        public static func `default`(size: FontSize) -> UIFont {
            return Fonts.default(size: size.rawValue)
        }
        public static func `default`(size: Int) -> UIFont {
            return UIFont(name: defaultFont, size: CGFloat(size))!
        }

        public static func bold(size: FontSize) -> UIFont {
            return Fonts.bold(size: size.rawValue)
        }
        public static func bold(size: Int) -> UIFont {
            return UIFont(name: boldFont, size: CGFloat(size))!
        }

        public static func icons(size: FontSize) -> UIFont {
            return icons(size: size.rawValue)
        }
        public static func icons(size: Int) -> UIFont {
            return icons(size: CGFloat(size))
        }
        public static func icons(size: CGFloat) -> UIFont {
            return UIFont(name: iconsFont, size: size)!
        }
    }

    public static func applyStyles() {

    }
}
