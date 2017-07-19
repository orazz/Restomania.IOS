//
//  OrderSummary.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class OrderSummary: BaseDataType {

    public var UserID: Int64?
    public var PlaceID: Int64
    public var KeyWord: String
    public var Comment: String
    public var OrderDate: Date
    public var CompleteDate: Date
    public var UserName: String
    public var PlaceName: String
    public var Currency: CurrencyType

    public override init() {
        self.UserID = 0
        self.PlaceID = 0
        self.KeyWord = String.Empty
        self.Comment = String.Empty
        self.OrderDate = Date()
        self.CompleteDate = Date()
        self.UserName = String.Empty
        self.PlaceName = String.Empty
        self.Currency = .EUR

        super.init()
    }
    public required init(json: JSON) {
        self.UserID = "UserID" <~~ json
        self.PlaceID = ("PlaceID" <~~ json)!
        self.KeyWord = ("KeyWord" <~~ json)!
        self.Comment = ("Comment" <~~ json)!
        self.OrderDate = ("OrderDate" <~~ json)!
        self.CompleteDate = ("CompleteDate" <~~ json)!
        self.UserName = ("UserName" <~~ json)!
        self.PlaceName = ("PlaceName" <~~ json)!
        self.Currency = ("Currency" <~~ json)!

        super.init(json: json)
    }
}
