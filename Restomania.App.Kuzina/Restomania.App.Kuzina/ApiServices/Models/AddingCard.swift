//
//  AddingCard.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class AddingCard: Gloss.Decodable {

    public struct Keys {
        public static let cardId = "ID"
        public static let summary = "Summary"
    }

    public let CardID: Int64
    public let Summary: TransactionSummary

    public init() {

        self.CardID = 0
        self.Summary = TransactionSummary()
    }

    // MARK: Decodable

    public required init(json: JSON) {

        self.CardID = (Keys.cardId <~~ json)!
        self.Summary = (Keys.summary <~~ json)!
    }
}
