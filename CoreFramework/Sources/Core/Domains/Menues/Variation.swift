//
//  Variation.swift
//  CoreFramework
//
//  Created by Алексей on 30.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import Gloss

public class Variation: BaseDataType, ICached, IMenuDependent, ISortable {

    public struct Keys {
        public static let menuId = "MenuId"
        public static let orderNumber = "OrderNumber"

        public static let parentDishId = "ParentDishId"
        public static let name = "Name"
        public static let price = "Price"
        public static let size = "Size"
        public static let sizeUnits = "SizeUnits"
    }

    public let menuId: Long
    public let orderNumber: Int

    public let parentDishId: Long
    public let name: String
    public let price: Price
    public let size: Double
    public var sizeUnits: UnitsOfSize

    public override init() {

        self.menuId = 0
        self.orderNumber = 0

        self.parentDishId = 0
        self.name = String.empty
        self.price = Price.zero
        self.size = 0.0
        self.sizeUnits = .units

        super.init()
    }

    //ICopying
    public required init(source: Variation) {

        self.menuId = source.menuId
        self.orderNumber = source.orderNumber

        self.parentDishId = source.parentDishId
        self.name = source.name
        self.price = source.price
        self.size = source.size
        self.sizeUnits = source.sizeUnits

        super.init(source: source)
    }

    //Glossy
    public required init(json: JSON) {

        self.menuId = (Keys.menuId <~~ json)!
        self.orderNumber = (Keys.orderNumber <~~ json)!

        self.parentDishId = (Keys.parentDishId <~~ json)!
        self.name = (Keys.name <~~ json)!
        self.price = (Keys.price <~~ json)!
        self.size = (Keys.size <~~ json)!
        self.sizeUnits = (Keys.sizeUnits <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([
            super.toJSON(),

            Keys.menuId ~~> self.menuId,
            Keys.orderNumber ~~> self.orderNumber,

            Keys.parentDishId ~~> self.parentDishId,
            Keys.name ~~> self.name,
            Keys.price ~~> self.price,
            Keys.size ~~> self.size,
            Keys.sizeUnits ~~> self.sizeUnits
            ])
    }
}
