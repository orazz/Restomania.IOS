//
//  PositionServiceDelegate.swift
//  CoreFramework
//
//  Created by Алексей on 12.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation

public protocol PositionServiceDelegate {

    func updateLocation(positions: [PositionsService.Position])
}
