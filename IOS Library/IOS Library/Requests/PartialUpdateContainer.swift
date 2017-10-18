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
    public convenience init(property: String, update: Any?) {

        if let value = update as? Gloss.Encodable {

            var jsonUpdate = "{}"

            do {

                if let json = value.toJSON() {
                    let data = try JSONSerialization.data(withJSONObject: json, options: [])
                    jsonUpdate = String(data: data, encoding: .utf8)!
                }
            } catch {}

            self.init(property: property, update:"\(jsonUpdate)")
        }
        else {
            self.init(property: property, update: "\(update ?? String.empty)")
        }
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



    public static func collect(_ range: [String:Any?]) -> [PartialUpdateContainer] {

        var result = [PartialUpdateContainer]()

        for (key, value) in range {
            result.append(PartialUpdateContainer(property: key, update: value))
        }

        return result
    }
}
