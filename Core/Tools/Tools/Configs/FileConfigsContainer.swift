//
//  FileConfigsContainer.swift
//  CoreTools
//
//  Created by Алексей on 12.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

open class FileConfigsContainer: ConfigsContainer {

    public var appKey: String
    public var serverUrl: String

    public var appType: AppType
    public var appUserRole: ApiRole

    public var placeId: Long?
    public var wedId: Long?

    public func get<TConfig>(_ key: String) -> TConfig? {
        return storage.get(forKey: key)
    }

    public func get<TConfig>(_ key: ConfigKey) -> TConfig? {
        return storage.get(forKey: key)
    }


    private let storage: ConfigsStorage

    public init(plistName: String = "Configs") {

        storage = ConfigsStorage(plistName: plistName)
        
        appKey = storage.get(forKey: ConfigKey.appKey)!
        serverUrl = storage.get(forKey: ConfigKey.serverUrl)!

        
        let type: String = storage.get(forKey: ConfigKey.appType)!
        appType = AppType(rawValue: type)!

        let role: String = storage.get(forKey: ConfigKey.appUserRole)!
        appUserRole = StringApiRole(rawValue: role)!.role


        placeId = storage.get(forKey: ConfigKey.placeId)
        wedId = storage.get(forKey: ConfigKey.webId)
    }
}
