//
//  DishStopId.swift
//  CoreFramework
//
//  Created by Алексей on 10.04.2018.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import Gloss

public class DishStopId: BaseDataType, ICached {
    private struct Keys {
        fileprivate static let dishid = "DishId"
        fileprivate static let type = "Type"
    }

    public let dishid: Long
    public let type: StopDishType

    public override init() {
        self.dishid = 0
        self.type = .dish

        super.init()
    }
    public required init(source: DishStopId) {
        self.dishid = source.dishid
        self.type = source.type

        super.init(source: source)
    }
    public required init(json: JSON) {
        self.dishid = (Keys.dishid <~~ json)!
        self.type = (Keys.type <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([

            Keys.dishid ~~> self.dishid,
            Keys.type ~~> self.type,

            super.toJSON()
            ])
    }
}
