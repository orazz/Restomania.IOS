//
//  Account.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import IOSLibrary

public class Account: BaseDataType {

    public struct Keys {
        public static let email = "Email"
        public static let name = "Name"
        public static let rights = "Rights"
        public static let currency = "CurrencyType"
    }

    public var Email: String
    public var Name: String
    public var Rights: ApiRole
    public var CurrencyType: CurrencyType

    public override init() {
        self.Email = String.empty
        self.Name = String.empty
        self.Rights = .user
        self.CurrencyType = .RUB

        super.init()
    }

    // MARK: Glossy
    public required init(json: JSON) {
        self.Email = (Keys.email <~~ json) ?? String.empty
        self.Name = (Keys.name <~~ json)!
        self.Rights = (Keys.rights <~~ json) ?? .user
        self.CurrencyType = (Keys.currency <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([
            super.toJSON(),

            Keys.email ~~> self.Email,
            Keys.name ~~> self.Name,
            Keys.rights ~~> self.Rights,
            Keys.currency ~~> self.CurrencyType
            ])
    }
}
