//
//  ServicesManager.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class ServicesManager: ILoggable {

    public static var current: ServicesManager!
    public class func initialize() {
        current = ServicesManager()
        Log.Info(current.tag, "Initialize manager.")
    }

    public var tag: String {
        return "ServicesManager"
    }
    public let keysStorage: IKeysStorage

    public init() {
        keysStorage = KeysStorage()
    }

}
