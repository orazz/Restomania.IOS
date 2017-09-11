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

public class PlaceSummary: ICached {

    public struct Keys {

        public static let ID = BaseDataType.Keys.ID
        public static let Name = "Name"
        public static let Description = "Description"
        public static let `Type` = "Type"
        public static let Kitchen = "Kitchen"
        public static let Rating = "Rating"
        public static let Image = "Image"
        public static let Location = "Location"
        public static let Schedule = "Schedule"
    }

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
    public required init(source: PlaceSummary) {

        self.ID = source.ID
        self.Name = source.Name
        self.Description = source.Description
        self.Type = source.Type
        self.Kitchen = source.Kitchen
        self.Rating = source.Rating
        self.Image = source.Image

        self.Location = PlaceLocation(source: source.Location)
        self.Schedule = ShortSchedule(source: source.Schedule)
    }
    public required init(json: JSON) {

        self.ID = (Keys.ID <~~ json)!
        self.Name = (Keys.Name <~~ json)!
        self.Description = (Keys.Description <~~ json)!
        self.Type = (PlaceSummary.Keys.Type <~~ json)!
        self.Kitchen = (Keys.Kitchen <~~ json)!
        self.Rating = (Keys.Rating <~~ json)!
        self.Image = (Keys.Image <~~ json)!

        self.Location = (Keys.Location <~~ json) ?? PlaceLocation()
        self.Schedule = (Keys.Schedule <~~ json) ?? ShortSchedule()
    }

    public func toJSON() -> JSON? {
        return jsonify([
            Keys.ID ~~> self.ID,
            Keys.Name ~~> self.Name,
            Keys.Description ~~> self.Description,
            PlaceSummary.Keys.Type ~~> self.Type,
            Keys.Kitchen ~~> self.Kitchen,
            Keys.Rating ~~> self.Rating,
            Keys.Image ~~> self.Image,

            Keys.Location ~~> self.Location,
            Keys.Schedule ~~> self.Schedule
            ])
    }
}
