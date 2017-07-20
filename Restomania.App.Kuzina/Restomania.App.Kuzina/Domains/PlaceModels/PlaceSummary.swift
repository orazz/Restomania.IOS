//
//  PlaceSummary.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 20.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import IOSLibrary

public class PlaceSummary: Glossy {

    public var ID: Long
    public var Name: String
    public var Description: String
    public var `Type`: PlaceType
    public var Kitchen: KitchenType
    public var Rating: Double
    public var Image: String
    public var Location: PlaceLocation
    public var Schedule: ShortSchedule

    public init() {
        self.ID = 0
        self.Name = String.Empty
        self.Description = String.Empty
        self.Type = .Restaurant
        self.Kitchen = .European
        self.Rating = 0
        self.Image = String.Empty
        self.Location = PlaceLocation()
        self.Schedule = ShortSchedule()
    }
    public required init(json: JSON) {
        self.ID = ("ID" <~~ json)!
        self.Name = ("Name" <~~ json)!
        self.Description = ("Description" <~~ json)!
        self.Type = ("Type" <~~ json)!
        self.Kitchen = ("Kitchen" <~~ json)!
        self.Rating = ("Rating" <~~ json)!
        self.Image = ("Image" <~~ json)!
        self.Location = ("Location" <~~ json) ?? PlaceLocation()
        self.Schedule = ("Schedule" <~~ json) ?? ShortSchedule()
    }

    public func toJSON() -> JSON? {
        return jsonify([
            "ID" ~~> self.ID,
            "Name" ~~> self.Name,
            "Description" ~~> self.Description,
            "Type" ~~> self.Type,
            "Kitchen" ~~> self.Kitchen,
            "Rating" ~~> self.Rating,
            "Image" ~~> self.Image,
            "Location" ~~> self.Location,
            "Schedule" ~~> self.Schedule
            ])
    }
}
