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

public class Recommendation: BaseDataType, ICached, IMenuDependent, ISortable {
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

    public override init() {
        self.menuId = 0
        self.orderNumber = 0

        self.sourceDishId = 0
        self.recommendingId = 0
        self.recommendingType = .simpleDish

        super.init()
    }
    public required init(source: Recommendation) {
        self.menuId = source.menuId
        self.orderNumber = source.orderNumber

        self.sourceDishId = source.sourceDishId
        self.recommendingId = source.recommendingId
        self.recommendingType = source.recommendingType

        super.init(source: source)
    }
    public required init(json: JSON) {
        self.menuId = (Keys.menuId <~~ json)!
        self.orderNumber = (Keys.orderNumber <~~ json)!

        self.sourceDishId = (Keys.sourceDishId <~~ json)!
        self.recommendingId = (Keys.recommendingId <~~ json)!
        self.recommendingType = (Keys.recommendingType <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([
            Keys.menuId ~~> self.menuId,
            Keys.orderNumber ~~> self.orderNumber,

            Keys.sourceDishId ~~> self.sourceDishId,
            Keys.recommendingId ~~> self.recommendingId,
            Keys.recommendingType ~~> self.recommendingType,

            super.toJSON()
            ])
    }
}
