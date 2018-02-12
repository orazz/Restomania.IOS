//
//  User.swift
//  Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class User: Account {

    public struct Keys {
        public static let sex = "Sex"
        public static let birthday = "BirthDay"
        public static let phone = "PhoneNumber"
        public static let avatar = "AvatarLink"
    }

    public var Sex: UserSex
    public var BirthDay: Date
    public var PhoneNumber: String
    public var AvatarLink: String

    public override init() {
        self.Sex = .Male
        self.BirthDay = Date()
        self.PhoneNumber = String.empty
        self.AvatarLink = String.empty

        super.init()
    }

    // MARK: Glossy
    public required init(json: JSON) {
        self.Sex = (Keys.sex <~~ json)!
        self.BirthDay = (Keys.birthday <~~ json)!
        self.PhoneNumber = (Keys.phone <~~ json)!
        self.AvatarLink = (Keys.avatar <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([
            super.toJSON(),

            Keys.sex ~~> self.Sex,
            Keys.birthday ~~> self.BirthDay.prepareForJson(),
            Keys.phone ~~> self.PhoneNumber,
            Keys.avatar ~~> self.AvatarLink
            ])
    }
}
