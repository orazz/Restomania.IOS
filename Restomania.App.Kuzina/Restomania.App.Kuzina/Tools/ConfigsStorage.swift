//
//  ConfigsStorage.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 20.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

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

    public func Get(forKey key: String) -> OptionalValue<Any> {
        if (!IsLoaded) {
            return OptionalValue(nil)
        }

        return OptionalValue(_configs.value[key])
    }
}
