//
//  Location.swift
//  Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class PlaceLocation: BaseDataType, ICopying {

    public struct Keys {
        public static let latitude = "Latitude"
        public static let longitude = "Longitude"
        public static let city = "City"
        public static let street = "Street"
        public static let house = "House"
    }

    public let Latitude: Double
    public let Longitude: Double
    public let City: String
    public let Street: String
    public let House: String

    public override init() {

        self.Latitude = 0
        self.Longitude = 0
        self.City = String.empty
        self.Street = String.empty
        self.House = String.empty

        super.init()
    }

    // MARK: ICopying
    public required init(source: PlaceLocation) {

        self.Latitude = source.Latitude
        self.Longitude = source.Longitude
        self.City = source.City
        self.Street = source.Street
        self.House = source.House

        super.init(source: source)
    }

    // MARK: Glossy
    public required init(json: JSON) {

        self.Latitude = (Keys.latitude <~~ json)!
        self.Longitude = (Keys.longitude <~~ json)!
        self.City = (Keys.city <~~ json)!
        self.Street = (Keys.street <~~ json)!
        self.House = (Keys.house <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([
            super.toJSON(),

            Keys.latitude ~~> self.Latitude,
            Keys.longitude ~~> self.Longitude,
            Keys.city ~~> self.City,
            Keys.street ~~> self.Street,
            Keys.house ~~> self.House
            ])
    }
}
