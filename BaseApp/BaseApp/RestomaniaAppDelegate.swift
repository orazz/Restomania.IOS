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

open class RestomaniaAppDelegate: UIResponder, UIApplicationDelegate {

    public var window: UIWindow?
    public private(set) var delegate: CustomAppDelegate!

    private let _tag = String.tag(RestomaniaAppDelegate.self)
    private var info: LaunchInfo!
    private var configs: ConfigsContainer!

    override public init() {
        super.init()

        loadInjections()

        info = DependencyResolver.resolve(LaunchInfo.self)
        configs = DependencyResolver.resolve(ConfigsContainer.self)
    }

    open func application(_ delegate: CustomAppDelegate, for application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.delegate = delegate

        delegate.beforeLoad()

        info.displayToLog()
        configs.displayToLog()

        migrate()
        
        loadTheme()
        loadCache()
        launchServices()

        delegate.afterLoad()

        return true
    }
    private func loadInjections() {

        let container = Container()

        ToolsServices.register(in: container)
        ApiServices.register(in: container)
        StorageServices.register(in: container)
        UIServices.register(in: container)

        delegate?.registerInjections(container)

        DependencyResolver.setup(container)
    }
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
    private func loadTheme() {

        UITools.customizeTheme(from: DependencyResolver.container)
        delegate?.customizeTheme()
    }
    private func loadCache() {

        StorageServices.load(from: DependencyResolver.container)
    }
    private func launchServices() {

//        ApiKeysRefreshser.launch()
//        PushesService.launch()
    }
}
extension RestomaniaAppDelegate {

//    public func application(_ application: UIApplication,
//                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        NotificationsServices.shared.completeRequestToPushNotifications(token: deviceToken)
//    }
//    public func application(_ application: UIApplication,
//                            didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        NotificationsServices.shared.completeRequestToPushNotifications(token: nil, error: error)
//    }
//    public func application(_ application: UIApplication,
//                            didReceiveRemoteNotification userInfo: [AnyHashable : Any],
//                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        NotificationsServices.shared.processMessage(push: userInfo)
//
//        completionHandler(.newData)
//    }
}
