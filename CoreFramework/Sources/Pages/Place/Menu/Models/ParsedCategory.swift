//
//  ParsedCategory.swift
//  CoreFramework
//
//  Created by Алексей on 20.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class ParsedCategory: ISortable {

    public private(set) var child: [ParsedCategory]
    public let dishes: [Dish]
    public private(set) var dishesWithDependent: [Dish]

    public let source: MenuCategory
    public let menu: MenuSummary

    public init(source: MenuCategory, from menu: MenuSummary) {

        self.source = source
        self.menu = menu

        self.child = []
        self.dishes = menu.dishes.filter({ $0.categoryId == source.id }).ordered
        self.dishesWithDependent = []
    }
    internal func set(child: [ParsedCategory]) {
        self.child = child

        var dishes = self.dishes
        for category in child {
            dishes = dishes + category.dishes
        }
        self.dishesWithDependent = dishes
    }


    public var id: Long {
        return source.id
    }
    public var parentId: Long? {
        return source.parentId
    }
    public var name: String {
        return source.name
    }
    public var orderNumber: Int {
        return source.orderNumber
    }
    public var isPublic: Bool {
        return !isHidden
    }
    public var isHidden: Bool {
        return source.isHidden
    }
    public var hasDishes: Bool {
        return dishesWithDependent.isFilled
    }
    public var noDishes: Bool {
        return dishesWithDependent.isEmpty
    }
    public var isBase: Bool {
        return source.isBase
    }
    public var isDependent: Bool {
        return source.isDependent
    }
}
