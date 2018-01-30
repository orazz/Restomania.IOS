//
//  Adding.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 30.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import IOSLibrary

public class Adding: BaseDataType, ICached, IMenuDependent, ISortable {

    public struct Keys {
        public static let menuId = "MenuId"
        public static let orderNumber = "OrderNumber"

        public static let sourceDishId = "SourceDishId"
        public static let addedDishId = "AddedDishId"
        public static let addedCategoryId = "AddedCategoryId"
    }

    public let menuId: Long
    public let orderNumber: Int

    public let sourceDishId: Long
    public let addedDishId: Long?
    public let addedCategoryId: Long?

    public override init() {

        self.menuId = 0
        self.orderNumber = 0

        self.sourceDishId = 0
        self.addedDishId = nil
        self.addedCategoryId = nil

        super.init()
    }

    //ICopying
    public required init(source: Adding) {

        self.menuId = source.menuId
        self.orderNumber = source.orderNumber

        self.sourceDishId = source.sourceDishId
        self.addedDishId = source.addedDishId
        self.addedCategoryId = source.addedCategoryId

        super.init(source: source)
    }

    //Glossy
    public required init(json: JSON) {

        self.menuId = (Keys.menuId <~~ json)!
        self.orderNumber = (Keys.orderNumber <~~ json)!

        self.sourceDishId = (Keys.sourceDishId <~~ json)!
        self.addedDishId = Keys.addedDishId <~~ json
        self.addedCategoryId = Keys.addedCategoryId <~~ json

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([
            super.toJSON(),

            Keys.menuId ~~> self.menuId,
            Keys.orderNumber ~~> self.orderNumber,

            Keys.sourceDishId ~~> self.sourceDishId,
            Keys.addedDishId ~~> self.addedDishId,
            Keys.addedCategoryId ~~> self.addedCategoryId
            ])
    }
}
