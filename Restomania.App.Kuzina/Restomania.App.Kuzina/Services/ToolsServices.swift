//
//  ToolsServices.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 04.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class ToolsServices {

    public static let shared = ToolsServices()

    public let configs: ConfigsStorage
    public let keys: KeysStorage

    private init()  {

        configs = ConfigsStorage(plistName: "Configs")
        keys = KeysStorage()
    }
}
