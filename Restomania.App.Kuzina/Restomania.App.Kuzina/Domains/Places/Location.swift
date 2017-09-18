//
//  Location.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import IOSLibrary

public class PlaceLocation: BaseDataType, ICopying {

    public var Latitude: Double
    public var Longitude: Double
    public var City: String
    public var Street: String
    public var House: String

    public override init() {

        self.Latitude = 0
        self.Longitude = 0
        self.City = String.Empty
        self.Street = String.Empty
        self.House = String.Empty

        super.init()
    }
    public required init(json: JSON) {

        self.Latitude = ("Latitude" <~~ json)!
        self.Longitude = ("Longitude" <~~ json)!
        self.City = ("City" <~~ json)!
        self.Street = ("Street" <~~ json)!
        self.House = ("House" <~~ json)!

        super.init(json: json)
    }
    public required init(source: PlaceLocation) {

        self.Latitude = source.Latitude
        self.Longitude = source.Longitude
        self.City = source.City
        self.Street = source.Street
        self.House = source.House

        super.init(source: source)
    }

    public override func toJSON() -> JSON? {
        return jsonify([
            "Latitude" ~~> self.Latitude,
            "Longitude" ~~> self.Longitude,
            "City" ~~> self.City,
            "Street" ~~> self.Street,
            "House" ~~> self.House,
            super.toJSON()
            ])!
    }
}
