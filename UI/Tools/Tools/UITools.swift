//
//  UITools.swift
//  UITools
//
//  Created by Алексей on 20.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import Toast_Swift
import NotificationBannerSwift

open class UITools {

    public static func customizeTheme(from container: Container) {

        let colors = container.resolve(ThemeColors.self)!
        let fonts = container.resolve(ThemeFonts.self)!
//        let images = container.resolve(ThemeImages.self)!

        UIApplication.shared.statusBarStyle = colors.defaultStatusBar
        
        //Navigation bar
        let navigationBar = UINavigationBar.appearance()
        navigationBar.backgroundColor = colors.navigationMain
        navigationBar.barTintColor = colors.navigationMain
        navigationBar.tintColor = colors.navigationContent
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: colors.navigationContent]

        stylizeToasts(fonts)
        stylizeBanner(colors, fonts)
    }
    private static func stylizeToasts(_ fonts: ThemeFonts) {

        var style = ToastStyle()
        style.messageFont = fonts.default(size: .subhead)

        ToastManager.shared.style = style
        ToastManager.shared.isQueueEnabled = false
    }
    private static func stylizeBanner(_ colors: ThemeColors, _ fonts: ThemeFonts) {

        let banner = NotificationBanner.appearance()

        banner.titleLabel?.font = fonts.bold(size: .head)
        banner.titleLabel?.textColor = colors.actionContent

        banner.subtitleLabel?.font = fonts.default(size: .subhead)
        banner.subtitleLabel?.textColor = colors.actionContent

        banner.backgroundColor = colors.actionMain
    }
}

