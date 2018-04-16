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
    public private(set) var source: MenuSummary!
    public private(set) var stoplist: Stoplist!
    
    public var currency: Currency {
        return source.currency
    }
    
    public private(set) var categories: [ParsedCategory] = []
    public private(set) var dishes: [ParsedDish] = []

    internal init(source: MenuSummary) {
        update(by: source)
    }
    public func update(by menu: MenuSummary) {
        initialize(menu: menu, stoplist: menu.stoplist)
    }
    public func update(by stoplist: Stoplist) {
        initialize(menu: source, stoplist: stoplist)
    }
    private func initialize(menu: MenuSummary, stoplist: Stoplist) {

        self.source = menu
        self.stoplist = stoplist

        let sourceVariations = collectVariations()
        let sourceDishes = collectDishes()
        let sourceCategories = collectCategories()

        let openSimpleDishes = sourceDishes.filter({ $0.type == .simpleDish }).map({ $0.id })
        let openCategories = categories.map{ $0.id }
        let sourceAddings = collectAddings(openSimpleDishes: openSimpleDishes, openCategories: openCategories)

        self.dishes = sourceDishes.map{ ParsedDish(source: $0, currency: source.currency, variations: sourceVariations, addings: sourceAddings) }

        let allCategories = sourceCategories.map{ ParsedCategory(source: $0, dishes: self.dishes) }
        for category in allCategories {
            category.selectChild(categories: allCategories)
        }

        self.categories = allCategories.filter({ $0.hasDishes })
    }

    private func collectVariations() -> [Variation] {

        let needStop = stoplist.elements.filter({ $0.type == .variation }).map({ $0.elementId })

        return source.variations.filter({ !needStop.contains($0.id) }).ordered
    }
    private func collectDishes() -> [Dish] {

        let needStop = stoplist.elements.filter({ $0.type == .dishOrSet }).map({ $0.elementId })

        return source.dishes.filter({ !needStop.contains($0.id) }).ordered
    }
    private func collectCategories() -> [MenuCategory] {

        let needStop = stoplist.elements.map({ $0.elementId })

        return source.categories.filter({ !needStop.contains($0.id) && (nil == $0.parentId || !needStop.contains($0.parentId!)) }).ordered
    }
    private func collectAddings(openSimpleDishes:[Long], openCategories: [Long]) -> [Adding] {

        return source.addings.filter({ e in
                                if let id = e.addedDishId {
                                    return openSimpleDishes.contains(id)
                                }
                                else if let id = e.addedCategoryId {
                                    return openCategories.contains(id)
                                }
                                else {
                                    return false
                                }
                            })
                            .ordered
    }
}

