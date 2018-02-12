//
//  StorageKey.swift
//  CoreTools
//
//  Created by Алексей on 12.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation

open class LightStorageKey: RawRepresentable {
    public typealias RawValue = Int



    public static let appVersion = LightStorageKey(rawValue: 1)
    public static let appBuild = LightStorageKey(rawValue: 2)

    public static let apiKeys = LightStorageKey(rawValue: 3)

    public static let devicePushToken = LightStorageKey(rawValue: 20)



    public var rawValue: Int
    public required init(rawValue: Int) {
        self.rawValue = rawValue
    }

}
