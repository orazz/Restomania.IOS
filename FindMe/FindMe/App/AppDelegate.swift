//
//  AppDelegate.swift
//  FindMe
//
//  Created by Алексей on 10.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import IOSLibrary

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let _tag = String.tag(AppDelegate.self)
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        Log.Info(_tag, "App launch with options.")
//        stubForTesting()
        start()

        return true
    }
    private func start() {

        ThemeSettings.initializeStyles()

        ServicesFactory.shared.positions.requestPermission(always: true)
        RefreshDataManager.shared.register()
    }
    private func stubForTesting() {

        let factory = ToolsServices.shared
        let properties = factory.properties
        properties.set(.isShowExplainer, value: false)

        factory.keys.logout(.user)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        Log.Info(_tag, "App will resign active.")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        Log.Info(_tag, "App perform fetch active.")

        RefreshDataManager.shared.refreshData()

        completionHandler(.newData)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Log.Info(_tag, "App did enter background.")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        ServicesFactory.shared.positions.stopTracking()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        Log.Info(_tag, "App will enter to refeground.")
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

        ServicesFactory.shared.positions.startTracking()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        Log.Info(_tag, "App did become active.")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

        ServicesFactory.shared.positions.startTracking()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        Log.Info(_tag, "App will terminate.")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

