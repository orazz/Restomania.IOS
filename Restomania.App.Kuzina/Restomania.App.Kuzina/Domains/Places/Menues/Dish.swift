//
//  Dish.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class Dish: BaseDish {

    public struct Keys {

        public static let cookingTimeInMinutes = "CookingTimeInMinutes"
    }

    public var cookingTimeInMinutes: Int

    public override init() {
        self.cookingTimeInMinutes = 0

        super.init()
    }
    public required init(json: JSON) {
        self.cookingTimeInMinutes = (Keys.cookingTimeInMinutes <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {

        return jsonify([

            Keys.cookingTimeInMinutes ~~> self.cookingTimeInMinutes,

            super.toJSON()
            ])
    }
}
