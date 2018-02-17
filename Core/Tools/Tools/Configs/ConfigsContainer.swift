//
//  ConfigsContainer.swift
//  CoreTools
//
//  Created by Алексей on 12.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public protocol ConfigsContainer {

    var appKey: String { get }
    var serverUrl: String { get }

    var appType: AppType { get }
    var appUserRole: ApiRole { get }
    
    var placeId: Long? { get }
    var wedId: Long? { get }

    func get<TConfig>(_ key: String) -> TConfig?
    func get<TConfig>(_ key: ConfigKey) -> TConfig?

    func displayToLog()
}
