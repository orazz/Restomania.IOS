//
//  OrderedDish.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class OrderedDish: BaseDataType {

    public var DishID: Int64
    public var Name: String
    public var Price: Double
    public var Count: Int

    public override init() {
        self.DishID = 0
        self.Name = String.Empty
        self.Price = 0
        self.Count = 0

        super.init()
    }
    public required init(json: JSON) {
        self.DishID = ("DishID" <~~ json)!
        self.Name = ("Name" <~~ json)!
        self.Price = ("Price" <~~ json)!
        self.Count = ("Count" <~~ json)!

        super.init(json: json)
    }
}
