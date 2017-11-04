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

    public struct colors {

        public static let main = UIColor(red: 34, green: 31, blue: 30)
        public static let additional = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1)
        public static let grey = UIColor(colorLiteralRed: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        public static let border = UIColor(colorLiteralRed: 165/255, green: 165/255, blue: 165/255, alpha: 1)
        public static let background = UIColor(colorLiteralRed: 234/255, green: 234/255, blue: 234/255, alpha: 1)
    }

    public struct images {

        public static let bottomGradient = loadAsset(named: "bottom-gradient")
        public static let darkFilter = loadAsset(named: "dark-filter")
        public static let `default` = loadAsset(named: "default-image")
        public static let logoDark = loadAsset(named: "logo-dark")

        private static func loadAssert(named: String) -> UIImage {
            return UIImage(named: named, in: Bundle.main, compatibleWith: nil)!
        }
    }

    public struct fonts {

        public enum FontSize: Int {
            case title = 20
            case head = 17
            case subhead = 15
            case caption = 12
            case subcaption = 10
        }

        public static func `default`(size: FontSize) -> UIFont { }
        public static func `default`(size: Int) -> UIFont { }

        public static func bold(size: FontSize) -> UIFont { }
        public static func bold(size: Int) -> UIFont { }

        public static func icons(size: FontSize) {
            return icons(size: size.rawValue)
        }
        public static func icons(size: Int){}
    }

    public let fontAwesomeFont = "FontAwesome"
    public let susanBookFont = "Susan Book"
    public let susanBoldFont = "Susan Bold"

    public let titleFontSize = CGFloat(20)
    public let headlineFontsize = CGFloat(17)
    public let subheadFontSize = CGFloat(15)
    public let captionFontSize = CGFloat(12)

    public static func applyStyles() {
        
    }
}
