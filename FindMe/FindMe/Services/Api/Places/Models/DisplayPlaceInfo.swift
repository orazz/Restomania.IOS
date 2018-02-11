//
//  DisplayPlaceInfo.swift
//  FindMe
//
//  Created by Алексей on 27.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import Gloss

public class DisplayPlaceInfo: Glossy, ICached {

    public struct Keys {
        public static let id = "ID"
        public static let townId = "TownId"

        public static let name = "Name"
        public static let type = "Type"
        public static let description = "Description"
        public static let seatingCapacity = "SeatingCapacity"
        public static let lastAction = "LastAction"

        public static let images = "Images"

        public static let location = "Location"
        public static let contacts = "Contacts"
        public static let statistic = "ClientsStatistic"
    }

    public let ID: Long
    public let townId: Long?

    public let name: String
    public let type: String
    public let description: String
    public let seatingCapacity: Int
    public let lastAction: String?

    public let images: [PlaceImage]

    public let location: Location
    public let contacts: Contacts
    public let statistic: ClientsStatistic

    //MARK: ICopying
    public required init(source: DisplayPlaceInfo) {

        self.ID = source.ID
        self.townId = source.townId

        self.name = source.name
        self.type = source.type
        self.description = source.description
        self.seatingCapacity = source.seatingCapacity
        self.lastAction = source.lastAction

        self.images = source.images.map{ PlaceImage(source: $0) }

        self.location = Location(source: source.location)
        self.contacts = Contacts(source: source.contacts)
        self.statistic = ClientsStatistic(source: source.statistic)
    }
    //MARK: Glossy
    public required init(json: JSON) {

        self.ID = (Keys.id <~~ json)!
        self.townId = Keys.townId <~~ json

        self.name = (Keys.name <~~ json)!
        self.type = (Keys.type <~~ json)!
        self.description = (Keys.description <~~ json)!
        self.seatingCapacity = (Keys.seatingCapacity <~~ json)!
        self.lastAction = Keys.lastAction <~~ json

        self.images = (Keys.images <~~ json)!

        self.location = (Keys.location <~~ json)!
        self.contacts = (Keys.contacts <~~ json)!
        self.statistic = (Keys.statistic <~~ json)!
    }
    public func toJSON() -> JSON? {
        return jsonify([
            Keys.id ~~> self.ID,
            Keys.townId ~~> self.townId,

            Keys.name ~~> self.name,
            Keys.type ~~> self.type,
            Keys.description ~~> self.description,
            Keys.seatingCapacity ~~> self.seatingCapacity,
            Keys.lastAction ~~> self.lastAction,

            Keys.images ~~> self.images,

            Keys.location ~~> self.location,
            Keys.contacts ~~> self.contacts,
            Keys.statistic ~~> self.statistic,
            ])
    }
}
