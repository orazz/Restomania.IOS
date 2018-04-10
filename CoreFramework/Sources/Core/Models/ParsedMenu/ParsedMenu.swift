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

    public let source: MenuSummary
    public var currency: Currency {
        return source.currency
    }
    
    public let categories: [ParsedCategory]
    public let dishes: [ParsedDish]

    private let allCategories: [ParsedCategory]




    internal init(source: MenuSummary){

        self.allCategories = ParsedMenu.collectCategories(from: source)
        self.categories = allCategories.filter({ $0.hasDishes && $0.isPublic })
        self.dishes = ParsedMenu.collectDishes(from: allCategories, with: source)

        self.source = source
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

