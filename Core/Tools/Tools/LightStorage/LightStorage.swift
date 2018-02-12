//
//  LightStorage.swift
//  CoreTools
//
//  Created by Алексей on 13.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import Gloss

public protocol LightStorage {

    func set(_ key: LightStorageKey, value: Any)

    func get(_ key: LightStorageKey) -> String?
    func get(_ key: LightStorageKey) -> Int?
    func get(_ key: LightStorageKey) -> Long?
    func get(_ key: LightStorageKey) -> Float?
    func get(_ key: LightStorageKey) -> Double?
    func get(_ key: LightStorageKey) -> Date?
    func get<TType: JSONDecodable>(_ key: LightStorageKey) -> TType?
}
