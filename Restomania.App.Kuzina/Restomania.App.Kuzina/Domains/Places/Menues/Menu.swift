//
//  Menu.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class PlaceMenu: BaseDataType {
    public var Categories: [DishCategory]
    public var Dishes: [Dish]

    public override init() {
        self.Categories = [DishCategory]()
        self.Dishes = [Dish]()

        super.init()
    }
    public required init(json: JSON) {
        self.Categories = ("Categories" <~~ json) ?? [DishCategory]()
        self.Dishes = ("Dishes" <~~ json) ?? [Dish]()

        super.init(json: json)
    }
}
