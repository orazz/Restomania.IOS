//
//  DishCategory.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class DishCategory: BaseDataType {
    public var Name: String
    public var ImageLink: String?
    public var OrderNumber: Int
    public var ParentID: Long?

    public override init() {
        self.Name = String.Empty
        self.ImageLink = String.Empty
        self.OrderNumber = 0
        self.ParentID = nil

        super.init()
    }
    public required init(json: JSON) {
        self.Name = ("Name" <~~ json)!
        self.ImageLink = "ImageLink" <~~ json
        self.OrderNumber = ("OrderNumber" <~~ json)!
        self.ParentID = "ParentID" <~~ json

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {

        return jsonify([
            "Name" ~~> self.Name,
            "ImageLink" ~~> self.ImageLink,
            "OrderNumber" ~~> self.OrderNumber,
            "ParentID" ~~> self.ParentID,

            super.toJSON()
            ])
    }
}
