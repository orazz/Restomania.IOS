//
//  Localization.DishModals.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

extension DishModal {

    public enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(DishModal.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        //Actions
        case buttonsTryAddDish = "Buttons.TryAddDish"
        case buttonsAddToCart = "Buttons.AddToCart"

        //Titles
        case labelsSelectVariations = "Labels.SelectVariations"
        case labelsSelectAddings = "Labels.SelectAddings"
    }
}
