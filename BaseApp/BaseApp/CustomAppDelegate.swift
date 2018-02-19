//
//  CustomAppDelegate.swift
//  BaseApp
//
//  Created by Алексей on 20.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import Swinject
import CoreTools

public protocol CustomAppDelegate {

    func beforeLoad()
    func afterLoad()

    func register(in container: Container)
    func migrate(_ info: LaunchInfo)
    func loadCache()
    func customizeTheme()
}
