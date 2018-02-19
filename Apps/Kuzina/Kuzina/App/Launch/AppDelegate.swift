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

    private let _tag = String.tag(AppDelegate.self)

    public override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        super.delegate = self

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    //CustomAppDelegate
    public func beforeLoad() {}

    public func register(in container: Container) {

        container.register(ThemeColors.self, factory: { _ in ThemeSettings.Colors()})
    }
    public func migrate(_ info: LaunchInfo) {
        Migrations.apply(with: info)
    }
    public func loadCache() {}
    public func customizeTheme() {

        ThemeSettings.applyStyles()
    }

    public func afterLoad() {

        PushesService.shared.requestPermissions()
        RefreshManager.shared.checkApiKeys()
    }

//
//    // MARK: Push notifications
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        PushesService.shared.completeRequestToPushNotifications(token: deviceToken)
//    }
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        PushesService.shared.completeRequestToPushNotifications(token: nil, error: error)
//    }
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        PushesService.shared.processMessage(push: userInfo)
//
//        completionHandler(.newData)
//    }
}
