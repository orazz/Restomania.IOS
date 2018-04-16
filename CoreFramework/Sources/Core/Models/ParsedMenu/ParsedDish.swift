//
//  ParsedDish.swift
//  CoreFramework
//
//  Created by Алексей on 20.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class ParsedDish: ISortable, IIdentified {
    public let source: Dish
    public let currency: Currency

    public let addings: [Adding]
    public let variation: ParsedVariationsInfo?

    public init(source: Dish, currency: Currency, variations: [Variation], addings: [Adding]) {
        self.source = source
        self.currency = currency

        self.addings = addings.filter({ $0.sourceDishId == source.id })
                               
        if (source.type == .variableDish) {
            variation = ParsedVariationsInfo(source: source, currency: currency, variations: variations)
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
    public var size: Double {
        return source.size
    }
    public var sizeUnits: UnitsOfSize {
        return source.sizeUnits
    }
}
