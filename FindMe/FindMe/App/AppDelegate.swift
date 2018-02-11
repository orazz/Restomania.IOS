//
//  AppDelegate.swift
//  FindMe
//
//  Created by Алексей on 10.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let _tag = String.tag(AppDelegate.self)
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        Log.info(_tag, "App launch with options.")
        start()

        return true
    }
    private func start() {

        ThemeSettings.initialize()
        AppSummary.shared.launchApp()

        Migrations.apply()

        CacheServices.load()
        StreamServices.start()
        LogicServices.shared.load();

        RefreshDataManager.shared.launch()

        LogicServices.shared.positions.requestPermission(always: true)
    }
    private func setupForTesting() {

        let factory = ToolsServices.shared
        let properties = factory.properties
        properties.set(.isShowExplainer, value: false)

        factory.keys.logout(.user)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        Log.info(_tag, "App will resign active.")
    }
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        Log.info(_tag, "App perform fetch active.")

        RefreshDataManager.shared.refreshData(with: completionHandler)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Log.info(_tag, "App did enter background.")

        LogicServices.shared.positions.stopTracking()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        Log.info(_tag, "App will enter to refeground.")

        LogicServices.shared.positions.startTracking()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        Log.info(_tag, "App did become active.")

        LogicServices.shared.positions.startTracking()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        Log.info(_tag, "App will terminate.")
    }
}

