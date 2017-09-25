//
//  ConfigsStorage.swift
//  IOS Library
//
//  Created by Алексей on 20.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public class ConfigsStorage {

    private let _filename: String
    private let _configs: OptionalValue<NSDictionary>

    public init(plistName filename: String) {
        _filename = filename

        let manager = FileSystem()
        _configs = manager.loadBundlePlist(filename)
    }

    public var IsLoaded: Bool {
        return _configs.hasValue
    }

    public func get<TKey: RawRepresentable>(forKey key: TKey) -> OptionalValue<Any> {

        return get(forKey: "\(key.rawValue)")
    }
    public func get(forKey key: String) -> OptionalValue<Any> {

        if (!IsLoaded) {
            return OptionalValue(nil)
        }

        return OptionalValue(_configs.value[key])
    }
}
