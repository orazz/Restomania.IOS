//
//  StorageKey.swift
//  Kuzina
//
//  Created by Алексей on 20.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public enum PropertiesKey: Int {

    case Test = 1

    //App versioning
    case appVersion = 2
    case appBuild = 3

    //Cache service
    case PlacesSummariesUpdateTime = 4

    case devicePushToken = 20
}
