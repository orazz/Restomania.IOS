//
//  AppDelegate.swift
//  Kuzina
//
//  Created by Алексей on 10.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit
import Swinject
import BaseApp
import UITools
import CoreTools

@UIApplicationMain
class AppDelegate: RestomaniaAppDelegate, CustomAppDelegate {

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return super.application(self, for: application, didFinishLaunchingWithOptions: launchOptions)
    }

    //CustomAppDelegate
    public func beforeLoad() {}

    public func registerInjections(_ container: Container) {

        container.register(ThemeColors.self, factory: { _ in ThemeSettings.Colors()})
        container.register(ThemeImages.self, factory: { _ in ThemeSettings.Images()})
        container.register(ThemeFonts.self, factory: { _ in ThemeSettings.Fonts()})
    }
    public func coolectMigrations() -> [Int: Trigger] {
        return [:]
    }
    public func customizeTheme() {}

    public func afterLoad() {}
}
