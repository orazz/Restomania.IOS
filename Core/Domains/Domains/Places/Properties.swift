//
//  Properties.swift
//  CoreDomains
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class PlaceProperties: BaseDataType {

    public var FreeWIFI: Bool
    public var SmokingPlace: Bool
    public var NoSmokingPlace: Bool
    public var ChildrenArea: Bool
    public var Parking: Bool
    public var FoodTakeAway: Bool

    public override init() {
        self.FreeWIFI = false
        self.SmokingPlace = false
        self.NoSmokingPlace = false
        self.ChildrenArea = false
        self.Parking = false
        self.FoodTakeAway = false

        super.init()
    }
    public required init(json: JSON) {
        self.FreeWIFI = ("FreeWIFI" <~~ json)!
        self.SmokingPlace = ("SmokingPlace" <~~ json)!
        self.NoSmokingPlace = ("NoSmokingPlace" <~~ json)!
        self.ChildrenArea = ("ChildrenArea" <~~ json)!
        self.Parking = ("Parking" <~~ json)!
        self.FoodTakeAway = ("FoodTakeAway" <~~ json)!

        super.init(json: json)
    }

}
