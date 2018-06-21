//
//  AppDelegate.swift
//  BaseApp
//
//  Created by Алексей on 18.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import MdsKit 
import FirebaseCore
import GoogleMaps

open class AppDelegate: UIResponder, UIApplicationDelegate {

    public private(set) var delegate: AppDelegateProtocol!
    public private(set) var launcher: Launcher!
    public var window: UIWindow?

    private let _tag = String.tag(AppDelegate.self)
    private var info: LaunchInfo!
    private var configs: ConfigsContainer!
    
    private let googleApiKey = "AIzaSyDJQShkaJLDBFJazHBG9kKibs-ACyYeSrw"

    open func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        loadInjections()
        
        return true
    }
    open func application(_ delegate: AppDelegateProtocol, for application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        self.delegate = delegate
        self.launcher = Launcher(for: self, with: launchOptions)
        self.window = launcher.window
        self.info = DependencyResolver.get(LaunchInfo.self)
        self.configs = DependencyResolver.get(ConfigsContainer.self)

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

        if let content = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
            let options = FirebaseOptions(contentsOfFile: content) {

            FirebaseApp.configure(options: options)
        }
        PushesService.shared.requestRemoteNotificattions()
        GMSServices.provideAPIKey(googleApiKey)
    }
    open func afterLoad() {

        let deviceService = DependencyResolver.get(DeviceService.self)

        guard let device = deviceService.device,
                let _ = device.accountId,
                device.build != info.build else {
            return
        }

        let request = deviceService.updateApp(device.id)
        request.async(.background)
    }



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

        container.register(Router.self, factory: { _ in DefaultRouter() }).inObjectScope(.container)

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

        PagesSearch.registerTemplates()
    }
}

//Notifications
extension AppDelegate {

    public func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        PushesService.shared.registerForRemoteNotifications(token: deviceToken)
    }
    public func application(_ application: UIApplication,
                            didFailToRegisterForRemoteNotificationsWithError error: Error) {

        PushesService.shared.registerForRemoteNotifications(token: nil, error: error)
    }
    public func application(_ application: UIApplication,
                            didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        if (UIApplication.shared.applicationState == .inactive) {

            let router = DependencyResolver.get(Router.self)

            if let container = PushContainer.tryParse(userInfo),
                let notification = PushesHandler.build(container),
                let vc = notification.controller,
                let navigator = router.navigator {
                navigator.pushViewController(vc, animated: true)
            }
        }
        else {
            PushesService.shared.processMessage(notification: userInfo, handler: completionHandler)
        }
    }
}

