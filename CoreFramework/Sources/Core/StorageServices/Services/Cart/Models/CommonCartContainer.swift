//
//  CommonCartContainer.swift
//  CoreFramework
//
//  Created by Алексей on 24.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import Gloss

internal class CommonCartContainer: Glossy {

    public var date: Date
    public var time: Date
    public var persons: Int
    public var places: [PlaceCartContainer]

    public init() {

        self.date = Date()
        self.time = Date()
        self.persons = 1
        self.places = [PlaceCartContainer]()
    }
    public required init?(json: JSON) {

        let date: String = ("date" <~~ json)!
        self.date = Date.parseJson(value: date)
        let time: String = ("time" <~~ json)!
        self.time = Date.parseJson(value: time)
        self.persons = ("persons" <~~ json)!
        self.places = ("places" <~~ json)!
    }

    public func toJSON() -> JSON? {

        return jsonify([
            "date" ~~> self.date.prepareForJson(),
            "time" ~~> self.time.prepareForJson(),
            "persons" ~~> self.persons,
            "places" ~~> self.places
            ])
    }

    public func clear() {

        date = Date()
        time = Date()
        persons = 1
        places.removeAll()
    }
}
