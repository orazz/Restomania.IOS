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
    public init(_ dish: Dish, count: Int) {

        self.DishID = dish.ID
        self.Name = dish.Name
        self.Price = dish.Price
        self.Count = count

        super.init()
    }
    public init(source: OrderedDish) {

        self.DishID = source.DishID
        self.Name = source.Name
        self.Price = source.Price
        self.Count = source.Count

        super.init(source: source)
    }

    public override func toJSON() -> JSON? {

        return jsonify([
            "DishID" ~~> self.DishID,
            "Name" ~~> self.Name,
            "Price" ~~> self.Price,
            "Count" ~~> self.Count,
            super.toJSON()!
            ])
    }
}
