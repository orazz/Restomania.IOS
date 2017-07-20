//
//  ShortSchedule.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 20.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class ShortSchedule: Glossy {

    public var Sunday: String
    public var Monday: String
    public var Tuesday: String
    public var Wednesday: String
    public var Thursday: String
    public var Friday: String
    public var Saturday: String

    public init() {
        self.Sunday = String.Empty
        self.Monday = String.Empty
        self.Tuesday = String.Empty
        self.Wednesday = String.Empty
        self.Thursday = String.Empty
        self.Friday = String.Empty
        self.Saturday = String.Empty
    }
    public required init(json: JSON) {
        self.Sunday = ("Sunday" <~~ json)!
        self.Monday = ("Monday" <~~ json)!
        self.Tuesday = ("Tuesday" <~~ json)!
        self.Wednesday = ("Wednesday" <~~ json)!
        self.Thursday = ("Thursday" <~~ json)!
        self.Friday = ("Friday" <~~ json)!
        self.Saturday = ("Saturday" <~~ json)!
    }

    public func toJSON() -> JSON? {
        return jsonify([
            "Sunday" ~~> Sunday,
            "Monday" ~~> Monday,
            "Tuesday" ~~> Tuesday,
            "Wednesday" ~~> Wednesday,
            "Thursday" ~~> Thursday,
            "Friday" ~~> Friday,
            "Saturday" ~~> Saturday
            ])
    }
}
