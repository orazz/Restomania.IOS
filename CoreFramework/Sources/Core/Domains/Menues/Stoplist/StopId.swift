//
//  StopId.swift
//  CoreFramework
//
//  Created by Алексей on 10.04.2018.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class StopId: BaseDataType, ICached {
    private struct Keys {
        fileprivate static let elementId = "ElementId"
        fileprivate static let type = "Type"
    }

    public let elementId: Long
    public let type: StopIdType

    public override init() {
        self.elementId = 0
        self.type = .dishOrSet

        super.init()
    }
    public required init(source: StopId) {
        self.elementId = source.elementId
        self.type = source.type

        super.init(source: source)
    }
    public required init(json: JSON) {
        self.elementId = (Keys.elementId <~~ json)!
        self.type = (Keys.type <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([

            Keys.elementId ~~> self.elementId,
            Keys.type ~~> self.type,

            super.toJSON()
            ])
    }
}
