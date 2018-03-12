//
//  PositionServiceDelegate.swift
//  CoreFramework
//
//  Created by Алексей on 12.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation

public protocol PositionServiceDelegate {

    func positionsService(_ service: PositionsService, update position: PositionsService.Position)
}
extension PositionServiceDelegate {

    public func positionsService(_ service: PositionsService, update position: PositionsService.Position) { }
}
