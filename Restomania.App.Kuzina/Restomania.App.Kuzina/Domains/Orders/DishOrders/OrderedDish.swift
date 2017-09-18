//
//  OrderedDish.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import IOSLibrary

public class OrderedDish: BaseDataType {

    public struct Keys {

        public static let dishId = "DishID"
        public static let name = "Name"
        public static let price = "Price"
        public static let count = "Count"
        public static let cost = "Cost"
    }

    public var DishID: Int64
    public var Name: String
    public var Price: PriceType
    public var Count: Int

    public var Cost: Double {

        return Price.double * Double(Count)
    }

    public override init() {

        self.DishID = 0
        self.Name = String.Empty
        self.Price = PriceType()
        self.Count = 0

        super.init()
    }
    public required init(json: JSON) {
        self.DishID = (Keys.dishId <~~ json)!
        self.Name = (Keys.name <~~ json)!
        self.Price = (Keys.price <~~ json)!
        self.Count = (Keys.count <~~ json)!

        super.init(json: json)
    }
    public init(_ dish: Dish, count: Int) {

        self.DishID = dish.ID
        self.Name = dish.name
        self.Price = dish.price
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
            Keys.dishId ~~> self.DishID,
            Keys.name ~~> self.Name,
            Keys.price ~~> self.Price,
            Keys.count ~~> self.Count,
            super.toJSON()!
            ])
    }
}
