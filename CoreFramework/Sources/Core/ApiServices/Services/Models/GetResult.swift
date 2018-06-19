//
//  GetResult.swift
//  CoreFramework
//
//  Created by Алексей on 19.06.2018.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import Gloss

public class GetResult<TData: JSONDecodable>: Glossy {

    public let entities: [TData]
    public let count: Long?

    public init() {
        self.entities = []
        self.count = nil
    }
    public init(_ data: [TData]){
        self.entities = data
        self.count = nil
    }

    public required init?(json: JSON) {
        self.entities = (Keys.data <~~ json)!
        self.count = Keys.count <~~ json
    }
    public func toJSON() -> JSON? {
        return jsonify([
            Keys.data ~~> self.entities,
            Keys.count ~~> self.count
        ])
    }
}
fileprivate struct Keys {
    public static let data = "Data"
    public static let count = "Count"
}
