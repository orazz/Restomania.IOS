//
//  ParsedCategory.swift
//  CoreFramework
//
//  Created by Алексей on 20.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class ParsedCategory: ISortable, IIdentified {

    public private(set) var child: [ParsedCategory]
    public let dishes: [ParsedDish]
    public var isHidden: Bool

    public let source: MenuCategory
    public init(source: MenuCategory, dishes: [ParsedDish]) {

        self.source = source
        self.child = []
        self.dishes = dishes.filter({ $0.categoryId == source.id })
        self.isHidden = source.isHidden
    }
    internal func selectChild(from categories: [ParsedCategory]) {
        self.child = categories.filter({ $0.parentId == source.id})

        if (self.isHidden) {
            for children in child {
                children.isHidden = true
            }
        }
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
    
    public var hasDishes: Bool {
        return dishes.isFilled
    }
    public var noDishes: Bool {
        return !hasDishes
    }
    public var hasDishesWithChild: Bool {
        return hasDishes || child.any({ $0.hasDishesWithChild })
    }

    public var isBase: Bool {
        return source.isBase
    }
    public var isDependent: Bool {
        return source.isDependent
    }
}
