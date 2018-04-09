//
//  ParsedDish.swift
//  CoreFramework
//
//  Created by Алексей on 20.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class ParsedDish: ISortable {


    public let source: Dish
    public let menu: MenuSummary

    public let addings: [Adding]
    public let variation: ParsedVariationsInfo?

    public init(source: Dish, from menu: MenuSummary) {
        self.source = source
        self.menu = menu

        self.addings = menu.addings.filter({ $0.sourceDishId == source.id }).ordered
        if (source.type == .variableDish) {
            variation = ParsedVariationsInfo(source: source, from: menu)
        }
        else {
            variation = nil
        }
    }

    public var id: Long {
        return source.id
    }
    public var categoryId: Long? {
        return source.categoryId
    }
    public var type: DishType {
        return source.type
    }
    public var name: String {
        return source.name
    }
    public var description: String {
        return source.description
    }
    public var image: String {
        return source.image
    }
    public var orderNumber: Int {
        return source.orderNumber
    }
    public var price: Price {
        return source.price
    }
    public var currency: Currency {
        return menu.currency
    }
    public var size: Double {
        return source.size
    }
    public var sizeUnits: UnitsOfSize {
        return source.sizeUnits
    }
}
