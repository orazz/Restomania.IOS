//
//  AddingCard.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import IOSLibrary

public class AddingCard: Gloss.Decodable {

    public struct Keys {
        public static let ID = BaseDataType.Keys.ID
        public static let currency = "Currency"
        public static let link = "Link"
    }

    public let ID: Int64
    public let currency: CurrencyType
    public let link: String

    public init() {

        self.ID = 0
        self.currency = .All
        self.link = String.empty
    }

    // MARK: Decodable

    public required init(json: JSON) {

        self.ID = (Keys.ID <~~ json)!
        self.currency = (Keys.currency <~~ json)!
        self.link = (Keys.link <~~ json)!
    }
}
