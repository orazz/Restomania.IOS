//
//  Stoplist.swift
//  CoreFramework
//
//  Created by Алексей on 10.04.2018.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class Stoplist: BaseDataType, ICached, PlaceDependentProtocol {
    private struct Keys {
        fileprivate static let placeId = "PlaceId"

        fileprivate static let elements = "Elements"
    }

    public let placeId: Long

    public let elements: [StopId]

    public override init() {
        placeId = 0

        elements = []

        super.init()
    }
    public required init(source: Stoplist) {
        self.placeId = source.placeId

        self.elements = source.elements.map { StopId(source: $0) }

        super.init(source: source)
    }
    public required init(json: JSON) {
        self.placeId = (Keys.placeId <~~ json)!

        self.elements = (Keys.elements <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([

            Keys.placeId ~~> self.placeId,

            Keys.elements ~~> self.elements,

            super.toJSON()
            ])
    }
}
