//
//  BaseAppDelegate.swift
//  BaseApp
//
//  Created by Алексей on 18.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import CoreTools

open class RestomaniaAppDelegate: UIResponder, UIApplicationDelegate {

    private let tag = String.tag(RestomaniaAppDelegate.self)
    public var window: UIWindow?

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {



        let info = DependencyResolver.resolve(LaunchInfo.self)
        let configs = DependencyResolver.resolve(ConfigsContainer.self)

        info.displayToLog()
        configs.displayToLog()
        

        AppSettings.launch()
        ThemeSettings.applyStyles()
        Migrations.apply()

        CacheServices.load()

        PushesService.shared.requestPermissions()
        RefreshManager.shared.checkApiKeys()

        return true
    }
}
