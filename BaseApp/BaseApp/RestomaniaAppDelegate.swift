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

    private let _tag = String.tag(RestomaniaAppDelegate.self)
    public var window: UIWindow?
    public var delegate: CustomAppDelegate?

    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        delegate?.beforeLoad()

        DependencyResolver.buildContainer({ container in
            delegate?.register(in: container)
        })

        let info = DependencyResolver.resolve(LaunchInfo.self)
        info.displayToLog()

        let configs = DependencyResolver.resolve(ConfigsContainer.self)
        configs.displayToLog()

        delegate?.migrate(info)
        delegate?.customizeTheme()

        delegate?.afterLoad()

        return true
    }
    private func loadCache() {
        
    }
}
