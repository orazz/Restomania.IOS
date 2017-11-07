//
//  BaseDish.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 13.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class BaseDish: BaseDataType, IMenuDependent, ISortable {

    public struct Keys {

        public static let menuId = "MenuId"

        public static let orderNumber = "OrderNumber"

        public static let categoryId = "CategoryId"
        public static let name = "Name"
        public static let description = "Description"
        public static let type = "Type"
        public static let price = "Price"
        public static let image = "Image"
        public static let size = "Size"
        public static let sizeUnits = "SizeUnits"
    }

    public var menuId: Long
    public var orderNumber: Int

    public var categoryId: Long?
    public var name: String
    public var description: String
    public var type: DishType
    public var price: PriceType
    public var image: String
    public var size: Double
    public var sizeUnits: UnitsOfSize

    public override init() {

        menuId = 0
        orderNumber = 0

        categoryId = nil
        name = String.empty
        description = String.empty
        type = .simpleDish
        price = PriceType()
        image = String.empty
        size = 0
        sizeUnits = .units

        super.init()
    }

    // MARK: Glossy
    public required init(json: JSON) {

        self.menuId = (Keys.menuId <~~ json)!
        self.orderNumber = (Keys.orderNumber <~~ json)!

        self.categoryId = Keys.categoryId <~~ json
        self.name = (Keys.name <~~ json)!
        self.description = (Keys.description <~~ json)!
        self.type = (Keys.type <~~ json)!
        self.price = (Keys.price <~~ json)!
        self.image = (Keys.image <~~ json)!
        self.size = (Keys.size <~~ json)!
        self.sizeUnits = (Keys.sizeUnits <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([

            Keys.menuId ~~> self.menuId,
            Keys.orderNumber ~~> self.orderNumber,

            Keys.categoryId ~~> self.categoryId,
            Keys.name ~~> self.name,
            Keys.description ~~> self.description,
            Keys.type ~~> self.type,
            Keys.price ~~> self.price,
            Keys.image ~~> self.image,
            Keys.size ~~> self.size,
            Keys.sizeUnits ~~> self.sizeUnits,

            super.toJSON()
            ])
    }
}
