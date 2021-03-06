//
//  UITools.swift
//  UITools
//
//  Created by Алексей on 20.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift
import NotificationBannerSwift

open class UITools {

    public static func customizeTheme() {

        let colors = DependencyResolver.get(ThemeColors.self)
        let fonts = DependencyResolver.get(ThemeFonts.self)

        UIApplication.shared.statusBarStyle = colors.statusBarOnNavigation
        
        //Navigation bar
        let navigationBar = UINavigationBar.appearance()
        navigationBar.isTranslucent = false
        navigationBar.isOpaque = true
        navigationBar.backgroundColor = colors.navigationMain
        navigationBar.barTintColor = colors.navigationMain
        navigationBar.tintColor = colors.navigationContent
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: colors.navigationContent]

        //Table
        let table = UITableView.appearance()
        table.backgroundColor = colors.contentBackground

        //Cell
        let cell = UITableViewCell.appearance()
        cell.backgroundColor = colors.contentBackground

        stylizeToasts(colors, fonts)
        stylizeBanner(colors, fonts)

        registerFonts()
    }
    private static func stylizeToasts(_ colors: ThemeColors, _ fonts: ThemeFonts) {

        var style = ToastStyle()
        style.backgroundColor = colors.notificationMain
        style.titleColor = colors.notificationContent
        style.messageFont = fonts.default(size: .subhead)

        ToastManager.shared.style = style
        ToastManager.shared.isQueueEnabled = false
    }
    private static func stylizeBanner(_ colors: ThemeColors, _ fonts: ThemeFonts) {

        let banner = NotificationBanner.appearance()
//
//        banner.titleLabel?.font = fonts.bold(size: .head)
//        banner.titleLabel?.textColor = colors.actionContent
//
//        banner.subtitleLabel?.font = fonts.default(size: .subhead)
//        banner.subtitleLabel?.textColor = colors.notificationContent

        banner.tintColor = colors.notificationContent
        banner.backgroundColor = colors.notificationMain
    }
    private static func registerFonts() {

        let bundle = Bundle.coreFramework

        let fonts = [
            bundle.url(forResource: "FontAwesome", withExtension: "ttf")
            ]

        for url in fonts.flatMap({ $0 }) {
            if let dataProvider = CGDataProvider(url: url as CFURL),
                let font = CGFont(dataProvider) {
                CTFontManagerRegisterGraphicsFont(font, nil)
            }
        }
    }
}

