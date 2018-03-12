//
//  Theme.swift
//  Kuzina
//
//  Created by Алексей on 21.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import CoreFramework

public class ThemeSettings {

    public class Colors: ThemeColors {

        public static let main = UIColor(red: 34, green: 31, blue: 30)
        public static let additional = UIColor(red: 255, green: 255, blue: 255)
        public static let grey = UIColor(red: 234, green: 234, blue: 234)
        public static let border = UIColor(red: 165, green: 165, blue: 165)
        public static let background = UIColor(red: 234, green: 234, blue: 234)

        public static let black = Colors.main
        public static let white = Colors.additional
        public static let pink = UIColor(red: 223, green: 25, blue: 149)

        // MARK: ThemeColors
        public var statusBarOnNavigation = UIStatusBarStyle.lightContent
        public var statusBarOnContent = UIStatusBarStyle.default
        public var navigationMain = Colors.black
        public var navigationContent = Colors.white

        public var actionMain = Colors.black
        public var actionDisabled = UIColor(red: 249, green: 249, blue: 249)
        public var actionContent = Colors.white

        public var notificationMain = Colors.black
        public var notificationContent = Colors.white

        public var contentBackground = Colors.white
        public var contentBackgroundText = Colors.black
        public var contentDivider = UIColor(red: 234, green: 234, blue: 234)
        public var contentDividerText = Colors.black
        public var contentSelection = UIColor(red: 244, green: 244, blue: 244)
        public var contentTempText = UIColor(red: 234, green: 234, blue: 234)

        public init() {}
    }

    public class Images: ThemeImages {

        public var logo = loadAssert(named: "logo-dark")

        private static func loadAssert(named: String) -> UIImage {
            return UIImage(named: named, in: Bundle.main, compatibleWith: nil)!
        }
    }

    public class Fonts: ThemeFonts {}
}
