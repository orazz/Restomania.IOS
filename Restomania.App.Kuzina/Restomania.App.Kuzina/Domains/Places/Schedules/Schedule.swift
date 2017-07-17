//
//  Schedule.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class PlaceSchedule: BaseDataType {
    public var Sunday: Day
    public var Monday: Day
    public var Tuesday: Day
    public var Wednesday: Day
    public var Thursday: Day
    public var Friday: Day
    public var Saturday: Day

    public override init() {
        self.Sunday = Day()
        self.Monday = Day()
        self.Tuesday = Day()
        self.Wednesday = Day()
        self.Thursday = Day()
        self.Friday = Day()
        self.Saturday = Day()

        super.init()
    }
    public required init(json: JSON) {
        self.Sunday = ("Sunday" <~~ json)!
        self.Monday = ("Monday" <~~ json)!
        self.Tuesday = ("Tuesday" <~~ json)!
        self.Wednesday = ("Wednesday" <~~ json)!
        self.Thursday = ("Thursday" <~~ json)!
        self.Friday = ("Friday" <~~ json)!
        self.Saturday = ("Saturday" <~~ json)!

        super.init(json: json)
    }
}
