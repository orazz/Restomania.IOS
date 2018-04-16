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

    public let source: MenuCategory
    public init(source: MenuCategory, dishes: [ParsedDish]) {

        self.source = source
        self.child = []
        self.dishes = dishes.filter({ $0.categoryId == source.id })
    }
    internal func selectChild(categories: [ParsedCategory]) {
        self.child = categories.filter({ $0.parentId == source.id && $0.dishes.isFilled })

        for children in child {
            children.isHidden = self.isHidden
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
    public var isHidden: Bool {
        get {
            return source.isHidden
        }
        set {
            source.isHidden = newValue
        }
    }
    public var hasDishes: Bool {
        return allDishesWithChild.isFilled
    }
    public var noDishes: Bool {
        return allDishesWithChild.isEmpty
    }
    public var isBase: Bool {
        return source.isBase
    }
    public var isDependent: Bool {
        return source.isDependent
    }

    private var allDishesWithChildCached: [ParsedDish]?
    public var allDishesWithChild: [ParsedDish] {

        if let cached = allDishesWithChildCached {
            return cached
        }

        var result = dishes.map { $0 }
        for children in self.child {
            result = result + children.dishes
        }

        allDishesWithChildCached = result
        return result
    }

    private var publicDishesWithChildSource: [ParsedDish]?
    public var publicDishesWithChild: [ParsedDish] {

        if let cached = publicDishesWithChildSource {
            return cached
        }

        var result = dishes.map { $0 }
        for children in self.child.filter({ $0.isPublic }) {
            result = result + children.dishes
        }

        publicDishesWithChildSource = result
        return result
    }
}
