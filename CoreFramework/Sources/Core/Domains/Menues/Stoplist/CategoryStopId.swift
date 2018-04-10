//
//  CategoryStopId.swift
//  CoreFramework
//
//  Created by Алексей on 10.04.2018.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class CategoryStopId: BaseDataType, ICached {
    private struct Keys {
        fileprivate static let categoryId = "CategoryId"
    }

    public let categoryId: Long

    public override init() {
        self.categoryId = 0

        super.init()
    }
    public required init(source: CategoryStopId) {
        self.categoryId = source.categoryId

        super.init(source: source)
    }
    public required init(json: JSON) {
        self.categoryId = (Keys.categoryId <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([

            Keys.categoryId ~~> self.categoryId,

            super.toJSON()
            ])
    }
}
