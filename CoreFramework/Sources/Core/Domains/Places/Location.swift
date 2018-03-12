//
//  Location.swift
//  CoreDomains
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
        public static let address = "Address"
        public static let city = "City"
        public static let street = "Street"
        public static let house = "House"
        public static let metro = "Metro"
        public static let borough = "Borough"
    }

    public let latitude: Double
    public let longitude: Double
    public let address: String
    public let city: String
    public let street: String
    public let house: String
    public let metro: String
    public let borough: String

    public override init() {

        self.latitude = 0
        self.longitude = 0
        self.address = String.empty
        self.city = String.empty
        self.street = String.empty
        self.house = String.empty
        self.metro = String.empty
        self.borough = String.empty

        super.init()
    }

    // MARK: ICopying
    public required init(source: PlaceLocation) {

        self.latitude = source.latitude
        self.longitude = source.longitude
        self.address = source.address
        self.city = source.city
        self.street = source.street
        self.house = source.house
        self.metro = source.metro
        self.borough = source.borough

        super.init(source: source)
    }

    // MARK: Glossy
    public required init(json: JSON) {

        self.latitude = (Keys.latitude <~~ json)!
        self.longitude = (Keys.longitude <~~ json)!
        self.address = (Keys.address <~~ json)!
        self.city = (Keys.city <~~ json)!
        self.street = (Keys.street <~~ json)!
        self.house = (Keys.house <~~ json)!
        self.metro = (Keys.metro <~~ json)!
        self.borough = (Keys.borough <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([
            super.toJSON(),

            Keys.latitude ~~> self.latitude,
            Keys.longitude ~~> self.longitude,
            Keys.address ~~> self.address,
            Keys.city ~~> self.city,
            Keys.street ~~> self.street,
            Keys.house ~~> self.house,
            Keys.metro ~~> self.metro,
            Keys.borough ~~> self.borough,
            ])
    }
}
