//
//  Account.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class Account: BaseDataType {
    public var Email: String
    public var Name: String
    public var Rights: AccessRights
    public var CurrencyType: CurrencyType

    public override init() {
        self.Email = String.Empty
        self.Name = String.Empty
        self.Rights = .User
        self.CurrencyType = .RUB

        super.init()
    }
    public required init(json: JSON) {
        self.Email = ("Email" <~~ json)!
        self.Name = ("Name" <~~ json)!
        self.Rights = ("Rights" <~~ json)!
        self.CurrencyType = ("CurrencyType" <~~ json)!

        super.init(json: json)
    }
}
