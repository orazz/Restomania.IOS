//
//  Recommendation.swift
//  CoreFramework
//
//  Created by Алексей on 10.04.2018.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class Recommendation: BaseType, ICached, IMenuDependent, ISortable {
    private struct Keys {
        fileprivate static let menuId = "MenuId"
        fileprivate static let orderNumber = "OrderNumber"

        fileprivate static let sourceDishId = "SourceDishId"
        fileprivate static let recommendingId = "RecommendingId"
        fileprivate static let recommendingType = "RecommendingType"
    }

    public let menuId: Long
    public let orderNumber: Int

    public let sourceDishId: Long
    public let recommendingId: Long
    public let recommendingType: DishType

    public init() {
        self.menuId = 0
        self.orderNumber = 0

        self.sourceDishId = 0
        self.recommendingId = 0
        self.recommendingType = .simpleDish
    }
}
