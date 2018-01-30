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

        let manager = FileSystem(tag: String.tag(ConfigsStorage.self))
        _configs = manager.loadBundlePlist(filename)
    }

    public var IsLoaded: Bool {
        return _configs.hasValue
    }

    public func get<TKey: RawRepresentable, TValue>(forKey key: TKey) -> TValue? {

        return get(forKey: "\(key.rawValue)")
    }
    public func get<TValue>(forKey key: String) -> TValue? {

        if (!IsLoaded) {
            return nil
        }

        return _configs.value[key] as? TValue
    }
}
