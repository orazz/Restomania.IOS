//
//  PartialUpdateContainer.swift
//  IOS Library
//
//  Created by Алексей on 25.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class PartialUpdateContainer: Glossy {

    public struct Keys {

        public static let property = "Property"
        public static let update = "Update"
    }

    public let property: String
    public let update: String

    // MARK: Init for fill
    public init(property: String, update: String) {

        self.property = property
        self.update = update
    }
    public convenience init(property: String, update: Int) {

        self.init(property: property, update:"\(update)")
    }
    public convenience init(property: String, update: Long) {

        self.init(property: property, update:"\(update)")
    }
    public convenience init(property: String, update: Float) {

        self.init(property: property, update:"\(update)")
    }
    public convenience init(property: String, update: Double) {

        self.init(property: property, update:"\(update)")
    }
    public convenience init(property: String, update: Bool) {

        self.init(property: property, update:"\(update)")
    }
    public convenience init(property: String, update: Gloss.Encodable) {

        var jsonUpdate = "{}"

        do {

            if let json = update.toJSON() {
                let data = try JSONSerialization.data(withJSONObject: json, options: [])
                jsonUpdate = String(data: data, encoding: .utf8)!
            }
        } catch {}

        self.init(property: property, update:"\(jsonUpdate)")
    }

    // MARK: Glossy
    public required init?(json: JSON) {

        self.property = (Keys.property <~~ json)!
        self.update = (Keys.update <~~ json)!
    }
    public func toJSON() -> JSON? {

        return jsonify([

            Keys.property ~~> self.property,
            Keys.update ~~> self.update
            ])
    }
}
