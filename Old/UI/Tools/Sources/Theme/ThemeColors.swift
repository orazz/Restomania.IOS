//
//  File.swift
//  UITools
//
//  Created by Алексей on 20.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public protocol ThemeColors {

    var defaultStatusBar: UIStatusBarStyle { get }

    var navigationMain: UIColor { get }
    var navigationContent: UIColor { get }

    var actionMain: UIColor { get }
    var actionDisabled: UIColor { get }
    var actionContent: UIColor { get }

    var notificationMain: UIColor { get }
    var notificationContent: UIColor { get }

    var contentBackground: UIColor { get }
    var contentBackgroundText: UIColor { get }
    var contentDivider: UIColor { get }
    var contentDividerText: UIColor { get }
    var contentSelection: UIColor { get }
    var contentTempText: UIColor { get }
}

extension ThemeColors {

    private var black: UIColor {
        return UIColor(red: 34, green: 31, blue: 30)
    }
    private var white: UIColor {
        return UIColor(red: 255, green: 255, blue: 255)
    }

    public var defaultStatusBar: UIStatusBarStyle {
        return .lightContent
    }

    public var navigationMain: UIColor {
        return black
    }
    public var navigationContent: UIColor {
        return white
    }

    public var actionMain: UIColor {
        return black
    }
    public var actionDisabled: UIColor {
        return white
    }
    public var actionContent: UIColor {
        return white
    }

    public var notificationMain: UIColor {
        return black
    }
    public var notificationContent: UIColor {
        return white
    }

    public var contentBackground: UIColor {
        return UIColor(red: 234, green: 234, blue: 234)
    }
    public var contentBackgroundText: UIColor {
        return black
    }
    public var contentDivider: UIColor {
        return UIColor(red: 234, green: 234, blue: 234)
    }
    public var contentDividerText: UIColor {
        return black
    }
    public var contentSelection: UIColor {
        return UIColor(red: 244, green: 244, blue: 244)
    }
    public var contentTempText: UIColor {
        return UIColor(red: 234, green: 234, blue: 234)
    }
}
