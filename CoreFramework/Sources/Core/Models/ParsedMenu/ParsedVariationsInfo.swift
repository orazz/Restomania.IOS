//
//  ParsedVariationsInfo.swift
//  CoreFramework
//
//  Created by Алексей on 20.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class ParsedVariationsInfo {
    public let source: Dish
    public let currency: Currency

    public let range: [Variation]
    public let minPrice: Price?
    public let minSize: Double?
    public let minSizeUnits: UnitsOfSize?

    public init(source: Dish, currency: Currency, variations: [Variation]) {

        self.source = source
        self.currency = currency
        self.range = variations.filter({ $0.parentDishId == source.id }).ordered

        if let minByPrice = self.range.min(by: { $0.price < $1.price }) {
            self.minPrice = minByPrice.price
        }
        else {
            self.minPrice = nil
        }

        if let minByWeight = self.range.min(by: { $0.size < $1.size }) {
            self.minSize = minByWeight.size
            self.minSizeUnits = minByWeight.sizeUnits
        }
        else {
            self.minSize = nil
            self.minSizeUnits = nil
        }
    }
}
