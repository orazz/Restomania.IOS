//
//  User.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class User: Account {
    public var Sex: UserSex
    public var BirthDay: Date
    public var PhoneNumber: String
    public var AvatarLink: String

    public override init() {
        self.Sex = .Male
        self.BirthDay = Date()
        self.PhoneNumber = String.Empty
        self.AvatarLink = String.Empty

        super.init()
    }
    public required init(json: JSON) {
        self.Sex = ("Sex" <~~ json)!
        self.BirthDay = ("BirthDay" <~~ json)!
        self.PhoneNumber = ("PhoneNumber" <~~ json)!
        self.AvatarLink = ("AvatarLink" <~~ json)!

        super.init(json: json)
    }
}
