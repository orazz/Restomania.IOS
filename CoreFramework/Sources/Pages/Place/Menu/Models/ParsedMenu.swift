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

    public let categoriesForShow: [MenuCategory]


    public let source: MenuSummary

    internal init(source: MenuSummary){

        self.categoriesForShow = ParsedMenu.collectCategoriesForShow(from: source)

        self.source = source
    }

    public var categories: [MenuCategory] {
        return source.categories
    }
    public var currency: Currency {
        return source.currency
    }

    private static func collectCategoriesForShow(from menu: MenuSummary) -> [MenuCategory] {

        var result = [MenuCategory]()

        let notHidden = menu.categories.filter({ !$0.isHidden })
        let filtered = notHidden.filter({ $0.isBase }).ordered
        for category in filtered {

            if (menu.dishes.any({ $0.categoryId == category.id })) {
                result.append(category)
                continue
            }

            let dependents = notHidden.filter({ $0.parentId == category.id })
            if (dependents.isEmpty) {
                continue
            }

            for dependent in dependents {
                if (menu.dishes.any({ $0.categoryId == dependent.id })) {
                    result.append(category)
                    break
                }
            }
        }

        return result
    }
}

