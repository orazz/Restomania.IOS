//
//  PositionService.swift
//  FindMe
//
//  Created by Алексей on 27.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import CoreLocation

public class PositionService {

    public static let shared = PositionService()

    //MARK: Methods
    public var canUse: Bool {
        return true
    }
    public var isBlock: Bool {
        return !canUse
    }

    public func distance(to: Position) -> Int {

        if (isBlock) {
            return Int.max
        }

        return 435
    }

    public class Position {

        public let latitude: Double
        public let longtitude: Double

        public init(lat: Double, lng: Double){

            self.latitude  = lat
            self.longtitude = lng
        }
    }
}
