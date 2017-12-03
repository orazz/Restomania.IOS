//
//  SearchPlaceCard.swift
//  FindMe
//
//  Created by Алексей on 25.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class SearchPlaceCard: ICached {
    
    public struct Keys {
        
        public static let id = "ID"
        public static let name = "Name"
        public static let type = "Type"
        public static let description = "Description"
        public static let townId = "TownId"
        public static let peopleCount = "PeopleCount"
        
        public static let image = "Image"
        public static let location = "Location"
    }
    
    public let ID: Long
    public let name: String
    public let type: String
    public let description: String
    public let townId: Long?
    public let peopleCount: Long

    public let image: String
    public let location: Location
    
    public init() {
        
        ID = 0
        name = String.empty
        type = String.empty
        description = String.empty
        townId = nil
        peopleCount = 0

        image = String.empty
        location = Location()
    }
    public init(source: DisplayPlaceInfo) {

        ID = source.ID
        name = source.name
        type = source.type
        description = source.description
        townId = source.townId
        peopleCount = source.statistic.people

        image = source.images.first?.link ?? String.empty
        location = source.location
    }
    
    //MARK: ICopyng
    public required init(source: SearchPlaceCard) {
        
        ID = source.ID
        name = source.name
        type = source.type
        description = source.description
        townId = source.townId
        peopleCount = source.peopleCount

        image = source.image
        location = Location(source: source.location)
    }
    
    //MARK: Glossy
    public required init?(json: JSON) {
        
        self.ID = (Keys.id <~~ json)!
        self.name = (Keys.name <~~ json)!
        self.type = (Keys.type <~~ json)!
        self.description = (Keys.description <~~ json)!
        self.townId = Keys.townId <~~ json
        self.peopleCount = (Keys.peopleCount <~~ json)!

        self.image = (Keys.image <~~ json)!
        self.location = (Keys.location <~~ json)!
    }
    public func toJSON() -> JSON? {
    
        return jsonify([
            
            Keys.id ~~> self.ID,
            Keys.name ~~> self.name,
            Keys.type ~~> self.type,
            Keys.description ~~> self.description,
            Keys.townId ~~> self.townId,
            Keys.peopleCount ~~> self.peopleCount,

            Keys.image ~~> self.image,
            Keys.location ~~> self.location
            ])
    }
}
