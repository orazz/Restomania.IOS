//
//  PartialUpdateContainer.swift
//  IOS Library
//
//  Created by Алексей on 11.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class PartialUpdateContainer {

    public struct Keys {

        public static let Property = "Property"
        public static let Update = "Update"
    }

    public let Property: String
    public var Update: String

    private init(property: String, update: Any) {

        Property = property
        Update = "\(update)"
    }
    public convenience init(property: String, update: Int) {
        self.init(property: property, update: update)
    }
    public convenience init(property: String, update: Long) {
        self.init(property: property, update: update)
    }
    public convenience init(property: String, update: String) {
        self.init(property: property, update: update)
    }
    public convenience init(property: String, update: Bool) {
        self.init(property: property, update: update)
    }
    public convenience init(property: String, update: Date) {
        self.init(property: property, update: update.prepareForJson())
    }
    public convenience init(property: String, update: Encodable) {

        do {
            let json = update.toJSON() ?? [:]
            let data = try JSONSerialization.data(withJSONObject: json, options: [])

            self.init(property: property, update: String(data: data, encoding: .utf8)!)
        } catch {

            self.init(property: "", update: "{}")
        }
    }
}
