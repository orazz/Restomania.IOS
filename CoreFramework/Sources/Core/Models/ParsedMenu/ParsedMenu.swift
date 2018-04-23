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

    public private(set) var categories: [ParsedCategory] = []
    public private(set) var dishes: [ParsedDish] = []
    
    public var currency: Currency {
        return source.currency
    }

    internal init(source: MenuSummary) {
        initialize(menu: source, stoplist: source.stoplist)
    }
    private func initialize(menu: MenuSummary, stoplist: Stoplist) {

        self.source = menu
        self.stoplist = stoplist

        //Filter variations, dishes and categories. Apply stoplist
        let sourceCategories = collectCategories()
        let sourceDishes = collectDishes()
        let sourceVariations = collectVariations()

        //Filter allow addings
        let sourceAddings = collectAddings(simpleDishes: sourceDishes.filter({ $0.type == .simpleDish }).map({ $0.id }),
                                              categories: sourceCategories.map{ $0.id })

        //Build all dishes
        self.dishes = sourceDishes.map { ParsedDish(source: $0,
                                                   currency: source.currency,
                                                 variations: sourceVariations,
                                                    addings: sourceAddings) }

        //Build all categories
        self.categories = sourceCategories.map { ParsedCategory(source: $0,
                                                                  dishes: self.dishes) }
        for category in categories {
            category.selectChild(from: categories)
        }
    }

    private func collectVariations() -> [Variation] {

        let needStop = stoplist.elements.filter({ $0.type == .variation }).map({ $0.elementId })

        return source.variations.filter({ !needStop.contains($0.id) }).ordered
    }
    private func collectDishes() -> [Dish] {

        let needStop = stoplist.elements.filter({ $0.type == .dishOrSet }).map({ $0.elementId })

        return source.dishes.filter({ !$0.isHidden && !needStop.contains($0.id) }).ordered
    }
    private func collectCategories() -> [MenuCategory] {

        let needStop = stoplist.elements.map({ $0.elementId })

        return source.categories.filter({ !needStop.contains($0.id) && (nil == $0.parentId || !needStop.contains($0.parentId!)) }).ordered
    }
    private func collectAddings(simpleDishes:[Long], categories: [Long]) -> [Adding] {

        let addings = source.addings.filter({ a in
                                if let id = a.addedDishId {
                                    return simpleDishes.contains(id)
                                }
                                else if let id = a.addedCategoryId {
                                    return categories.contains(id)
                                }
                                else {
                                    return false
                                }
                            })

        return addings.ordered
    }



    public lazy var categoriesForDisplay: [ParsedCategory] = { [unowned self] in

        var result = [ParsedCategory]()

        for category in categories.filter({ $0.isBase && $0.isPublic }) {

            if (category.hasDishes) {
                result.append(category)
                continue
            }

            let dependents = category.child.filter({ $0.isPublic })
            if (dependents.any({ $0.hasDishes })) {
                result.append(category)
            }
        }

        return result
    }()

    public func publicDishesWithChild(for source: ParsedCategory) -> [ParsedDish] {

        var result = source.dishes
        
        for children in source.child.filter({ $0.isPublic }) {
            for dish in children.dishes {
                result.append(dish)
            }
        }

        return result
    }
}

