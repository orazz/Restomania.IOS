//
//  PlaceSummary.swift
//  Kuzina
//
//  Created by Алексей on 20.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class PlaceSummary: ICached {

    public struct Keys {

        public static let id = BaseDataType.Keys.ID
        public static let menuId = "MenuId"

        public static let name = "Name"
        public static let description = "Description"
        public static let type = "Type"
        public static let kitchen = "Kitchen"
        public static let rating = "Rating"
        public static let image = "Image"
        public static let location = "Location"
        public static let schedule = "Schedule"
    }

    public var ID: Long
    public var menuId: Long

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
        self.menuId = 0

        self.Name = String.empty
        self.Description = String.empty
        self.Type = .Restaurant
        self.Kitchen = .European
        self.Rating = 0
        self.Image = String.empty
        self.Location = PlaceLocation()
        self.Schedule = ShortSchedule()
    }
    public required init(source: PlaceSummary) {

        self.ID = source.ID
        self.menuId = source.menuId

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

        self.ID = (Keys.id <~~ json)!
        self.menuId = (Keys.menuId <~~ json)!

        self.Name = (Keys.name <~~ json)!
        self.Description = (Keys.description <~~ json)!
        self.Type = (Keys.type <~~ json)!
        self.Kitchen = (Keys.kitchen <~~ json)!
        self.Rating = (Keys.rating <~~ json)!
        self.Image = (Keys.image <~~ json)!

        self.Location = (Keys.location <~~ json) ?? PlaceLocation()
        self.Schedule = (Keys.schedule <~~ json) ?? ShortSchedule()
    }

    public func toJSON() -> JSON? {
        return jsonify([
            Keys.id ~~> self.ID,
            Keys.menuId ~~> self.menuId,

            Keys.name ~~> self.Name,
            Keys.description ~~> self.Description,
            Keys.type ~~> self.Type,
            Keys.kitchen ~~> self.Kitchen,
            Keys.rating ~~> self.Rating,
            Keys.image ~~> self.Image,

            Keys.location ~~> self.Location,
            Keys.schedule ~~> self.Schedule
            ])
    }
}
