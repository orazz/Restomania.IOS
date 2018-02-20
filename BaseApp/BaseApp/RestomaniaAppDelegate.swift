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
import CoreTools
import CoreStorageServices
import UITools

open class RestomaniaAppDelegate: UIResponder, UIApplicationDelegate {

    private let _tag = String.tag(RestomaniaAppDelegate.self)
    public var window: UIWindow?
    public var delegate: CustomAppDelegate?

    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        delegate?.beforeLoad()

        let info = DependencyResolver.resolve(LaunchInfo.self)
        info.displayToLog()

        let configs = DependencyResolver.resolve(ConfigsContainer.self)
        configs.displayToLog()

        delegate?.migrate(info)
        customizeTheme()
        loadCache()

        delegate?.afterLoad()

        return true
    }
    private func loadInjections() {

        let container = Container()

        ToolsServices.register(in: container)
        ApiServices.register(in: container)
        StorageServices.register(in: container)
        UIServices.register(in: container)

        delegate?.register(in: container)

        DependencyResolver.setup(container)
    }
    private func customizeTheme() {

        UITools.customizeTheme(from: DependencyResolver.container)
        delegate?.customizeTheme()
    }
    private func loadCache() {

        StorageServices.load(from: DependencyResolver.container)
        delegate?.loadCache()
    }
}
