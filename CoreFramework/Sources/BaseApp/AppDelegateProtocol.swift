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

public protocol AppDelegateProtocol {

    func coolectMigrations() -> [Int: Trigger]
}
