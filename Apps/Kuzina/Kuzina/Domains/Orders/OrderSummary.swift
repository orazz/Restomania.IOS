//
//  OrderSummary.swift
//  Kuzina
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class OrderSummary: BaseDataType, UserDependentProtocol, PlaceDependentProtocol {

    public struct Keys {

        public static let userId = "UserId"
        public static let placeId = "PlaceId"

        public static let codeword = "Codeword"
        public static let comment = "Comment"
        public static let completeAt = "CompleteAt"

        public static let userName = "UserName"
        public static let placeName = "PlaceName"
    }

    public let userId: Long
    public let placeId: Long

    public let codeword: String
    public let comment: String
    public let completeAt: Date

    public let userName: String
    public let placeName: String

    public override init() {

        self.userId = 0
        self.placeId = 0

        self.codeword = String.empty
        self.comment = String.empty
        self.completeAt = Date()

        self.userName = String.empty
        self.placeName = String.empty

        super.init()
    }
    //Glossy
    public required init(json: JSON) {

        self.userId = (Keys.userId <~~ json)!
        self.placeId = (Keys.placeId <~~ json)!

        self.codeword = (Keys.codeword <~~ json)!
        self.comment = (Keys.comment <~~ json)!
        self.completeAt = (Date.parseJson(value: (Keys.completeAt <~~ json)!))

        self.userName = (Keys.userName <~~ json)!
        self.placeName = (Keys.placeName <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([
            super.toJSON(),

            Keys.userId ~~> self.userId,
            Keys.placeId ~~> self.placeId,

            Keys.codeword ~~> self.codeword,
            Keys.comment ~~> self.comment,
            Keys.completeAt ~~> self.completeAt.prepareForJson(),

            Keys.userName ~~> self.userName,
            Keys.placeName ~~> self.placeName
            ])
    }
}
