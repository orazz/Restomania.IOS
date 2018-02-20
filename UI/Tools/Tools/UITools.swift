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

open class UITools {

    public static func customizeTheme(from container: Container) {

        let colors = container.resolve(ThemeColors.self)!

        UIApplication.shared.statusBarStyle = colors.defaultStatusBar
        
        //Navigation bar
        let navigationBar = UINavigationBar.appearance()
        navigationBar.backgroundColor = colors.navigationMain
        navigationBar.barTintColor = colors.navigationMain
        navigationBar.tintColor = colors.navigationContent
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: colors.navigationContent]
    }
}

