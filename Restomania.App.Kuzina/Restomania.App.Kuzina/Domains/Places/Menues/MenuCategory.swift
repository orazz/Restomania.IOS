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

public class MenuCategory: BaseDataType, IMenuDependent, ISortable {

    public struct Keys {

        public static let menuId = "MenuId"
        public static let orderNumber = "OrderNumber"

        public static let parentId = "ParentId"
        public static let name = "Name"
        public static let isHidden = "IsHidden"
    }

    public var menuId: Long
    public var orderNumber: Int

    public var parentId: Long?
    public var name: String
    public var isHidden: Bool

    public override init() {

        self.menuId = 0
        self.orderNumber = 0

        self.parentId = nil
        self.name = String.Empty
        self.isHidden = true

        super.init()
    }

    // MARK: Glossy
    public required init(json: JSON) {

        self.menuId = (Keys.menuId <~~ json)!
        self.orderNumber = (Keys.orderNumber <~~ json)!

        self.parentId = Keys.parentId <~~ json
        self.name = (Keys.name <~~ json)!
        self.isHidden = (Keys.isHidden <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {

        return jsonify([
            Keys.menuId ~~> self.menuId,
            Keys.orderNumber ~~> self.orderNumber,

            Keys.parentId ~~> self.parentId,
            Keys.name ~~> self.name,
            Keys.isHidden ~~> self.isHidden,

            super.toJSON()
            ])
    }
}
