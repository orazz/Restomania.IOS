//
//  DependencyResolver.swift
//  CoreTools
//
//  Created by Алексей on 21.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import Swinject

open class DependencyResolver {

    public private(set) static var container: Container = Container()

    open static func setup(_ container: Container) {
        DependencyResolver.container = container
    }
    open static func resolve<T>(_ type: T.Type) -> T {
        return container.resolve(type)!
    }
}

