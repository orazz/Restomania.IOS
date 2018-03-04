//
//  DefaultsLightStorage.swift
//  CoreTools
//
//  Created by Алексей on 13.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import Gloss

open class DefaultsLightStorage: LightStorage {

    private let storage: PropertiesStorage<LightStorageKey>
    public init() {
        storage = PropertiesStorage<LightStorageKey>()
    }



    public func set(_ key: LightStorageKey, value: Any) {

        if (value is String) {
            storage.set(key, value: value as! String)
        }
        else if (value is Int) {
            storage.set(key, value: value as! Int)
        }
        else if (value is Long) {
            storage.set(key, value: value as! Long)
        }
        else if (value is Float) {
            storage.set(key, value: value as! Float)
        }
        else if (value is Double) {
            storage.set(key, value: value as! Double)
        }
        else if (value is Date) {
            storage.set(key, value: value as! Date)
        }
        else if (value is Bool) {
            storage.set(key, value: value as! Bool)
        }
        else if (value is JSONEncodable) {
            storage.set(key, value: value as! JSONEncodable)
        }
    }

    public func get(_ key: LightStorageKey) -> String? {
        return storage.getString(key).unwrapped
    }
    public func get(_ key: LightStorageKey) -> Int? {
        return storage.getInt(key).unwrapped
    }
    public func get(_ key: LightStorageKey) -> Long? {
        return storage.getLong(key).unwrapped
    }
    public func get(_ key: LightStorageKey) -> Float? {
        return storage.getFloat(key).unwrapped
    }
    public func get(_ key: LightStorageKey) -> Double? {
        return storage.getDouble(key).unwrapped
    }
    public func get(_ key: LightStorageKey) -> Date? {
        return storage.getDate(key).unwrapped
    }
    public func get(_ key: LightStorageKey) -> Bool? {
        return storage.getBool(key).unwrapped
    }
    public func get<TType>(_ key: LightStorageKey) -> TType? where TType : JSONDecodable {
        return storage.get(TType.self, key: key).unwrapped
    }

    public func remove(_ key: LightStorageKey) {
        storage.remove(key)
    }
}
