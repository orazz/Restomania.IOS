//
//  Dish.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class Dish: BaseDataType {
    public var CategoryID: Int64?
    public var Name: String
    public var ImageLink: String
    public var Description: String
    public var Price: Double
    public var CookingTime: Int
    public var Weight: Double

    public override init() {
        self.CategoryID = 0
        self.Name = String.Empty
        self.ImageLink = String.Empty
        self.Description = String.Empty
        self.Price = 0
        self.CookingTime = 0
        self.Weight = 0

        super.init()
    }
    public required init(json: JSON) {
        self.CategoryID = "CategoryID" <~~ json
        self.Name = ("Name" <~~ json)!
        self.ImageLink = ("ImageLink" <~~ json)!
        self.Description = ("Description" <~~ json)!
        self.Price = ("Price" <~~ json)!
        self.CookingTime = ("CookingTime" <~~ json)!
        self.Weight = ("Weight" <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {

        return jsonify([
            "CategoryID" ~~> self.CategoryID,
            "Name" ~~> self.Name,
            "ImageLink" ~~> self.ImageLink,
            "Description" ~~> self.Description,
            "Price" ~~> self.Price,
            "CookingTime" ~~> self.CookingTime,
            "Weight" ~~> self.Weight,
            super.toJSON()
            ])
    }
}
