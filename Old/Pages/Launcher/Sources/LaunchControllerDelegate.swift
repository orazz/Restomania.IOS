//
//  LaunchControllerDelegate.swift
//  Launcher
//
//  Created by Алексей on 04.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public protocol LaunchControllerDelegate {

    var notNeedDisplay: Bool { get }
    var onCompleteHandler: Trigger? { get set }

    func hiddenProcessing()
}
