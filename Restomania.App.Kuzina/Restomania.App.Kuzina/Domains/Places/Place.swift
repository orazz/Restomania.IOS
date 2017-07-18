//
//  Place.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class Place: Account {
    public var Status: RegistrationStatus
    public var TableCount: Int
    public var LogoLink: String
    public var BackgroundImageLink: String
    public var Description: String
    public var `Type`: PlaceType
    public var KitchenType: KitchenType

    public var Properties: PlaceProperties
    public var Schedule: PlaceSchedule
    public var Location: PlaceLocation
    public var Contacts: PlaceContacts
    public var Menu: PlaceMenu
    public var Loyalty: PlaceLoyalty

    public override init() {
        self.Status = .Processing
        self.TableCount = 0
        self.LogoLink = String.Empty
        self.BackgroundImageLink = String.Empty
        self.Description = String.Empty
        self.Type = .Other
        self.KitchenType = .Russian

        self.Properties = PlaceProperties()
        self.Schedule = PlaceSchedule()
        self.Location = PlaceLocation()
        self.Contacts = PlaceContacts()
        self.Menu = PlaceMenu()
        self.Loyalty = PlaceLoyalty()

        super.init()
    }
    public required init(json: JSON) {
        self.Status = ("Status" <~~ json)!
        self.TableCount = ("TableCount" <~~ json)!
        self.LogoLink = ("LogoLink" <~~ json)!
        self.BackgroundImageLink = ("BackgroundImageLink" <~~ json)!
        self.Description = ("Description" <~~ json)!
        self.Type = ("Type" <~~ json)!
        self.KitchenType = ("KitchenType" <~~ json)!

        self.Properties = ("Properties" <~~ json)!
        self.Schedule = ("Schedule" <~~ json)!
        self.Location = ("Location" <~~ json)!
        self.Contacts = ("Contacts" <~~ json)!
        self.Menu = ("Menu" <~~ json)!
        self.Loyalty = ("Loyalty" <~~ json)!

        super.init(json: json)
    }
}
