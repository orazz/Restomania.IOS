//
//  ToolsServices.swift
//  CoreFramework
//
//  Created by Алексей on 04.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import Swinject

public class ToolsServices {

    open static func register(in container: Container) {

        container.register(LightStorage.self) { _ in DefaultsLightStorage() }.inObjectScope(.container)
        container.register(ConfigsContainer.self) { _ in FileConfigsContainer(plistName: "Configs") }.inObjectScope(.container)
        container.register(LaunchInfo.self) { r in LaunchInfo(r.resolve(LightStorage.self)!) }.inObjectScope(.container)
    }
}
