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

public class Town: Glossy, ICached {

    public struct Keys {
        public static let id = BaseDataType.Keys.ID
        public static let name = "Name"
        public static let latitude = "Latitude"
        public static let longtitude = "Longtitude"
    }

    public var ID: Long
    public let name: String
    public let latitude: Double
    public let longtitude: Double

    //MARK: ICopying
    public required init(source: Town) {

        self.ID = source.ID
        self.name = source.name
        self.latitude = source.latitude
        self.longtitude = source.longtitude
    }

    //MARK: Glossy
    public required init?(json: JSON) {

        self.ID = (Keys.id <~~ json)!
        self.name = (Keys.name <~~ json)!
        self.latitude = (Keys.latitude <~~ json)!
        self.longtitude = (Keys.longtitude <~~ json)!
    }
    public func toJSON() -> JSON? {
        return jsonify([
            Keys.id ~~> self.ID,
            Keys.name ~~> self.name,
            Keys.latitude ~~> self.latitude,
            Keys.longtitude ~~> self.longtitude
            ])
    }
}
