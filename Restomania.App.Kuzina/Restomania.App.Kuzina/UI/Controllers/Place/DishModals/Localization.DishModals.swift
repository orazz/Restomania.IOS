//
//  Localization.DishModals.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

extension Localization {

    public enum DishModals: String, Localizable {

        public var tableName: String {
            return String.tag(DishModals.self)
        }

        //Actions
        case buttonsTryAddDish = "Buttons.TryAddDish"
        case buttonsAddToCart = "Buttons.AddToCart"
    }
}
