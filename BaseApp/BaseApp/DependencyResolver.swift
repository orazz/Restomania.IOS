//
//  DependencyResolver.swift
//  CoreApp
//
//  Created by Алексей on 17.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import Swinject
import CoreTools
import CoreToolsServices
import CoreApiServices
import CoreStorageServices
import UIServices

public class DependencyResolver {

    private static let container: Container = buildContainer()

    private static func buildContainer() -> Container {

        let container = Container()

        ToolsServices.register(in: container)
        ApiServices.register(in: container)
        StorageServices.register(in: container)

        UIServices.register(in: container)

        return container
    }

    open static func resolve<T>(_ type: T.Type) -> T {
        return container.resolve(type)!
    }
}
