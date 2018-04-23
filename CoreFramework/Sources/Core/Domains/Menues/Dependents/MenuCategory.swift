//
//  DishCategory.swift
//  CoreDomains
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import Gloss

public class MenuCategory: BaseDataType, ICopying, IMenuDependent, ISortable {

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
        self.name = String.empty
        self.isHidden = true

        super.init()
    }

    public var isDependent: Bool {
        return nil != parentId
    }
    public var isBase: Bool {
        return nil == parentId
    }
    // ICopying
    public required init(source: MenuCategory) {

        self.menuId = source.menuId
        self.orderNumber = source.orderNumber

        self.parentId = source.parentId
        self.name = source.name
        self.isHidden = source.isHidden

        super.init(source: source)
    }

    // MARK: Glossy
    public required init(json: JSON) {

        self.menuId = (Keys.menuId <~~ json)!
        self.orderNumber = (Keys.orderNumber <~~ json)!

        self.parentId = Keys.parentId <~~ json

        let name: String = (Keys.name <~~ json)!
        self.name = name.trim()
        
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
extension MenuCategory: Hashable {
    public var hashValue: Int {
        return Int(id)
    }
    public static func ==(left: MenuCategory, right: MenuCategory) -> Bool {
        return left.id == right.id
    }
}
