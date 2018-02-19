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

    private let tag = String.tag(ConfigsContainer.self)
    public var appKey: String
    public var serverUrl: String

    public var appType: AppType
    public var appUserRole: ApiRole

    public var placeId: Long?
    public var chainId: Long?

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
        chainId = storage.get(forKey: ConfigKey.chainId)
    }

    public func displayToLog() {

        Log.info(tag, "App key: \(appKey).")
        Log.info(tag, "Server url: \(serverUrl).")

        Log.info(tag, "User role: \(appUserRole).")
        Log.info(tag, "Type: \(appType).")
        switch appType {
            case .Single:
                Log.info(tag, "Place ID: \(placeId!).")
            case .chain:
                Log.info(tag, "ChainId: \(chainId!).")
            default:
                Log.info(tag, "App is agregator.")
        }
        Log.info(tag, "")
    }
}
