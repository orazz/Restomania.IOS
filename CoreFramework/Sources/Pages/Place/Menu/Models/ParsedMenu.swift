//
//  ParsedMenu.swift
//  CoreFramework
//
//  Created by Алексей on 19.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class ParsedMenu {

    public let categories: [ParsedCategory]
    public let categoriesForShow: [ParsedCategory]
    public let dishes: [ParsedDish]


    public let source: MenuSummary

    internal init(source: MenuSummary){

        self.categories = ParsedMenu.collectCategories(from: source)
        self.categoriesForShow = categories.filter({ $0.hasDishes && $0.isPublic })
        self.dishes = ParsedMenu.collectDishes(from: categories, with: source)

        self.source = source
    }

    public var currency: Currency {
        return source.currency
    }

    private static func collectCategories(from menu: MenuSummary) -> [ParsedCategory] {

        let result = menu.categories.map({ ParsedCategory(source: $0, from: menu) }).ordered
        
        for category in result.filter({ $0.isBase }) {
            let dependents = result.filter({ $0.parentId == category.id })
            category.set(child: dependents)
        }

        return result
    }
    private static func collectDishes(from categories: [ParsedCategory], with menu: MenuSummary) -> [ParsedDish] {

        var result = menu.dishes.filter({ $0.categoryId == nil })
                                .map({ ParsedDish(source: $0, from: menu) })

        for category in categories {
            result = result + category.dishes
        }

        return result.ordered
    }
}

