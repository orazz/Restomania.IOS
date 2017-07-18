//
//  AddingCard.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class AddingCard: Decodable {
    public let CardID: Int64
    public let Summary: TransactionSummary

    public init() {
        self.CardID = 0
        self.Summary = TransactionSummary()
    }
    public required init(json: JSON) {
        self.CardID = ("ID" <~~ json)!
        self.Summary = ("Summary" <~~ json)!
    }
}
