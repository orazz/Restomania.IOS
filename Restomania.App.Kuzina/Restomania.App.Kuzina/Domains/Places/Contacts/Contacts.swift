//
//  Contacts.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import IOSLibrary

public class PlaceContacts: BaseDataType {

    public var PhoneNumber: String
    public var Email: String
    public var Website: String
    public var Links: [Link]

    public override init() {
        self.PhoneNumber = String.Empty
        self.Email = String.Empty
        self.Website = String.Empty
        self.Links = [Link]()

        super.init()
    }
    public required init(json: JSON) {
        self.PhoneNumber = ("PhoneNumber" <~~ json)!
        self.Email = ("Email" <~~ json)!
        self.Website = ("Website" <~~ json)!
        self.Links = ("Links" <~~ json) ?? [Link]()

        super.init(json: json)
    }
}
