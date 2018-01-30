//
//  Variation.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 30.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class Variation: BaseDataType, ICached, IMenuDependent, ISortable {

    public struct Keys {
        public static let menuId = "MenuId"
        public static let orderNumber = "OrderNumber"

        public static let parentDishId = "ParentDishId"
        public static let name = "Name"
        public static let size = "Size"
    }

    public let menuId: Long
    public let orderNumber: Int

    public let parentDishId: Long
    public let name: String
    public let size: Double

    public override init() {

        self.menuId = 0
        self.orderNumber = 0

        self.parentDishId = 0
        self.name = String.empty
        self.size = 0.0

        super.init()
    }

    //ICopying
    public required init(source: Variation) {

        self.menuId = source.menuId
        self.orderNumber = source.orderNumber

        self.parentDishId = source.parentDishId
        self.name = source.name
        self.size = source.size

        super.init(source: source)
    }

    //Glossy
    public required init(json: JSON) {

        self.menuId = (Keys.menuId <~~ json)!
        self.orderNumber = (Keys.orderNumber <~~ json)!

        self.parentDishId = (Keys.parentDishId <~~ json)!
        self.name = (Keys.name <~~ json)!
        self.size = (Keys.size <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([
            super.toJSON(),

            Keys.menuId ~~> self.menuId,
            Keys.orderNumber ~~> self.orderNumber,

            Keys.parentDishId ~~> self.parentDishId,
            Keys.name ~~> self.name,
            Keys.size ~~> self.size
            ])
    }
}
