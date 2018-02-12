//
//  Contacts.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class PlaceContacts: BaseDataType {

    public struct Keys {
        public static let phoneNumber = "PhoneNumber"
        public static let email = "Email"
        public static let website = "Website"
        public static let links = "Links"
    }

    public var PhoneNumber: String
    public var Email: String
    public var Website: String
    public var Links: [Link]

    public override init() {
        self.PhoneNumber = String.empty
        self.Email = String.empty
        self.Website = String.empty
        self.Links = [Link]()

        super.init()
    }

    // MARK: Glossy
    public required init(json: JSON) {
        self.PhoneNumber = (Keys.phoneNumber <~~ json)!
        self.Email = (Keys.email <~~ json)!
        self.Website = (Keys.website <~~ json)!
        self.Links = (Keys.links <~~ json) ?? [Link]()

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([
            super.toJSON(),

            Keys.phoneNumber ~~> self.PhoneNumber,
            Keys.email ~~> self.Email,
            Keys.website ~~> self.Website,
            Keys.links ~~> self.Links
            ])
    }
}
