//
//  Town.swift
//  FindMe
//
//  Created by Алексей on 28.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class Town: Glossy {

    public struct Keys {
        public static let id = BaseDataType.Keys.ID
        public static let name = "Name"
        public static let latitude = "Latitude"
        public static let longtitude = "Longtitude"
    }

    public let id: Long
    public let name: String
    public let latitude: Double
    public let longtitude: Double

    //MARK: Glossy
    public required init?(json: JSON) {

        self.id = (Keys.id <~~ json)!
        self.name = (Keys.name <~~ json)!
        self.latitude = (Keys.latitude <~~ json)!
        self.longtitude = (Keys.longtitude <~~ json)!
    }
    public func toJSON() -> JSON? {
        return jsonify([
            Keys.id ~~> self.id,
            Keys.name ~~> self.name,
            Keys.latitude ~~> self.latitude,
            Keys.longtitude ~~> self.longtitude
            ])
    }
}
