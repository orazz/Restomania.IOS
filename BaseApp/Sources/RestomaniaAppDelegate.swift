//
//  BaseAppDelegate.swift
//  BaseApp
//
//  Created by Алексей on 18.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import MdsKit
import CoreTools
import CoreToolsServices
import CoreApiServices
import CoreStorageServices
import UITools
import UIServices
import Launcher

open class AppDelegate: UIResponder, UIApplicationDelegate {

    public var window: UIWindow?
    public private(set) var delegate: CustomAppDelegate!
    public private(set) var launcher: Launcher!

    private let _tag = String.tag(AppDelegate.self)
    private var info: LaunchInfo!
    private var configs: ConfigsContainer!


    open func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        loadInjections()
        
        return true
    }
    open func application(_ delegate: CustomAppDelegate, for application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        self.delegate = delegate
        self.launcher = Launcher(for: self, with: launchOptions)
        self.info = DependencyResolver.resolve(LaunchInfo.self)
        self.configs = DependencyResolver.resolve(ConfigsContainer.self)

        beforeLoad()
        migrate()
        loadTheme()

        launcher.start(complete: {
            self.afterLoad()
        })

        return true
    }
    open func beforeLoad() {

        info.displayToLog()
        configs.displayToLog()
    }
    open func afterLoad() {}



    //MARK: DI
    private func loadInjections() {

        let container = Container()


        registerInjections(in: container)

        DependencyResolver.setup(container)
    }
    open func registerInjections(in container: Container) {

        ToolsServices.register(in: container)
        ApiServices.register(in: container)
        StorageServices.register(in: container)

        container.register(ThemeColors.self, factory: { _ in Colors() })
        container.register(ThemeFonts.self, factory: { _ in Fonts() })
        container.register(ThemeImages.self, factory: { _ in Images() })

        UIServices.register(in: container)
    }
    private class Colors: ThemeColors {}
    private class Fonts: ThemeFonts {}
    private class Images: ThemeImages {}



    //MARK: Migrations
    private func migrate() {

        guard let prevBuild = info.prevBuild else {
            return
        }

        let migrations = delegate.coolectMigrations()
        for (build, migration) in migrations.sorted(by: { $0.key < $1.key }) {

            if (prevBuild < build) {

                Log.info(tag, "Apply migration for \(build) build.")
                migration()
            }
        }
    }



    //MARK: customize theme
    private func loadTheme() {
        customizeTheme()
    }
    open func customizeTheme() {
        UITools.customizeTheme()
    }

//    private func loadCache() {
//
//        StorageServices.load(from: DependencyResolver.container)
//    }
//    private func launchServices() {
//
////        ApiKeysRefreshser.launch()
////        PushesService.launch()
//    }
}
//extension AppDelegate {
//
////    public func application(_ application: UIApplication,
////                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
////        NotificationsServices.shared.completeRequestToPushNotifications(token: deviceToken)
////    }
////    public func application(_ application: UIApplication,
////                            didFailToRegisterForRemoteNotificationsWithError error: Error) {
////        NotificationsServices.shared.completeRequestToPushNotifications(token: nil, error: error)
////    }
////    public func application(_ application: UIApplication,
////                            didReceiveRemoteNotification userInfo: [AnyHashable : Any],
////                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
////        NotificationsServices.shared.processMessage(push: userInfo)
////
////        completionHandler(.newData)
////    }
//}

