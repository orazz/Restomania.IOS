//
//  OrderSummary.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import IOSLibrary

public class OrderSummary: BaseDataType {

    public struct Keys {

        public static let userId = "UserID"
        public static let userName = "UserName"
        public static let placeId = "PlaceID"
        public static let placeName = "PlaceName"
        public static let keyword = "KeyWord"
        public static let comment = "Comment"
        public static let completeDate = "CompleteDate"
        public static let currency = "Currency"
    }

    public var UserID: Int64?
    public var UserName: String
    public var PlaceID: Int64
    public var PlaceName: String
    public var KeyWord: String
    public var Comment: String
    public var CompleteDate: Date
    public var Currency: CurrencyType

    public override init() {

        self.UserID = 0
        self.PlaceID = 0
        self.KeyWord = String.Empty
        self.Comment = String.Empty
        self.CompleteDate = Date()
        self.UserName = String.Empty
        self.PlaceName = String.Empty
        self.Currency = .EUR

        super.init()
    }
    public required init(json: JSON) {

        self.UserID = Keys.userId <~~ json
        self.UserName = (Keys.userName <~~ json)!
        self.PlaceID = (Keys.placeId <~~ json)!
        self.PlaceName = (Keys.placeName <~~ json)!
        self.KeyWord = (Keys.keyword <~~ json)!
        self.Comment = (Keys.comment <~~ json)!

        let completeDate: String = (Keys.completeDate <~~ json)!
        self.CompleteDate = (Date.parseJson(value: completeDate))
        self.Currency = (Keys.currency <~~ json)!

        super.init(json: json)
    }
}
