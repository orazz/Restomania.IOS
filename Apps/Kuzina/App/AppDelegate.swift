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
class AppDelegate: BaseApp.AppDelegate, AppDelegateProtocol {

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return super.application(self, for: application, didFinishLaunchingWithOptions: launchOptions)
    }

    //CustomAppDelegate
    open override func registerInjections(in container: Container) {
        super.registerInjections(in: container)

        container.register(ThemeColors.self, factory: { _ in ThemeSettings.Colors()})
        container.register(ThemeImages.self, factory: { _ in ThemeSettings.Images()})
        container.register(ThemeFonts.self, factory: { _ in ThemeSettings.Fonts()})
    }
    public func coolectMigrations() -> [Int: Trigger] {
        return [:]
    }

    override func customizeTheme() {
        super.customizeTheme()

        let bundle = Bundle.main
        let store = TemplateStore.shared

        store.searchPlaceCard(name: "SearchPlaceCard", from: bundle)
    }
}
