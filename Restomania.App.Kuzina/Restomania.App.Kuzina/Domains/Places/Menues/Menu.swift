//
//  Menu.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class PlaceMenu: BaseDataType, PlaceDependentProtocol {

    public struct Keys {

        public static let placeId = "PlaceId"

        public static let categories = "Categories"

        public static let dishes = "Dishes"
        public static let variations = "Variations"
        public static let addings = "Addings"
    }

    public var placeId: Long

    public var categories: [MenuCategory]

    public var dishes: [Dish]
    public var variations: [Variation]
    public var addings: [Adding]

    public override init() {

        self.placeId = 0

        self.categories = []

        self.dishes = []
        self.variations = []
        self.addings = []

        super.init()
    }
    public required init(json: JSON) {

        self.placeId = (Keys.placeId <~~ json)!

        self.categories = (Keys.categories <~~ json)!

        self.dishes = (Keys.dishes <~~ json)!
        self.variations = (Keys.variations <~~ json)!
        self.addings = (Keys.addings <~~ json)!

        super.init(json: json)
    }
}
