//
//  PlaceClient.swift
//  FindMe
//
//  Created by Алексей on 31.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class PlaceClient: BaseDataType {

    public struct Keys {

        public static let name = "Name"
        public static let image = "Image"
        public static let age = "Age"
        public static let sex = "Sex"
        public static let status = "Status"
    }

    public let name: String
    public let image: String
    public let age: Int
    public let sex: UserSex
    public let status: UserStatus

    public override init() {

        self.name = String.empty
        self.image = String.empty
        self.age = 21
        self.sex  = .unknown
        self.status = .readyForAcquaintance

        super.init()
    }

    //Glossy
    public required init(json: JSON) {

        self.name = (Keys.name <~~ json)!
        self.image = (Keys.image <~~ json)!
        self.age = (Keys.age <~~ json)!
        self.sex = (Keys.sex <~~ json)!
        self.status = (Keys.status <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {

        return jsonify([
            super.toJSON(),

            Keys.name ~~> self.name,
            Keys.image ~~> self.image,
            Keys.age ~~> self.age,
            Keys.sex ~~> self.sex,
            Keys.status ~~> self.status
            ])
    }
}
extension PlaceClient {

    public var needShow: Bool {
        return status == .readyForAcquaintance
    }
}
