//
//  PartnerStatus.swift
//  FindMe
//
//  Created by Алексей on 24.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class PartnerStatus: Glossy {

    private struct Keys {
        fileprivate static let id = BaseDataType.Keys.ID
        fileprivate static let name = "Name"
    }

    public let id: Long
    public let name: String

    public init() {

        self.id = 0
        self.name = String.empty
    }

    //MARK: Glossy
    public required init?(json: JSON) {

        self.id = (Keys.id <~~ json)!
        self.name = (Keys.name <~~ json)!
    }
    public func toJSON() -> JSON? {
        return jsonify([
            Keys.id ~~> self.id,
            Keys.name ~~> self.name
            ])
    }
}

