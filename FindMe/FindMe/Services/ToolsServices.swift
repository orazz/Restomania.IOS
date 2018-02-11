//
//  ToolsServices.swift
//  FindMe
//
//  Created by Алексей on 28.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class ToolsServices {

    public static let shared = ToolsServices()


    public let configs: ConfigsStorage
    public let properties: PropertiesStorage<PropertiesKey>
    public let backgroundTasks: BackgroundTasksService
    public let keys: KeysStorage

    private init() {

        configs = ConfigsStorage(plistName: "Configs")
        properties = PropertiesStorage<PropertiesKey>()
        backgroundTasks = BackgroundTasksService.shared
        keys = KeysStorage()
    }
}
