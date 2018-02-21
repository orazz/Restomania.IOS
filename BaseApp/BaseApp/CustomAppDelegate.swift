//
//  CustomAppDelegate.swift
//  BaseApp
//
//  Created by Алексей on 20.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import Swinject
import MdsKit
import CoreTools

public protocol CustomAppDelegate {

    func beforeLoad()
    func afterLoad()

    func registerInjections(_ container: Container)
    func coolectMigrations() -> [Int: Trigger]
    func customizeTheme()

}
