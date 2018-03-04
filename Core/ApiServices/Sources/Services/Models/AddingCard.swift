//
//  AddingCard.swift
//  Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit
import CoreDomains

public class AddingCard: JSONDecodable {

    public struct Keys {
        public static let id = BaseDataType.Keys.id
        public static let currency = "Currency"
        public static let link = "Link"
    }

    public let id: Long
    public let currency: CurrencyType
    public let link: String

    public init() {

        self.id = 0
        self.currency = .All
        self.link = String.empty
    }

    // MARK: Decodable

    public required init(json: JSON) {

        self.id = (Keys.id <~~ json)!
        self.currency = (Keys.currency <~~ json)!
        self.link = (Keys.link <~~ json)!
    }
}
