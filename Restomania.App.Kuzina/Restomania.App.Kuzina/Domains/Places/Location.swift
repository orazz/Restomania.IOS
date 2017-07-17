//
//  Location.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class PlaceLocation: BaseDataType {
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
}
