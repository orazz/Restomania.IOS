//
//  Localization.Tools.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 22.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

extension Localization {
    public class Tools {
        public static let tableName = "Tools"

        public enum Units: String, Localizable {

            public var tableName: String {
                return Tools.tableName
            }

            case Gram = "Units.Gram"
            case Kilogram = "Units.Kilogram"
            case Milliliter = "Units.Milliliter"
            case Liter = "Units.Liter"
            case Units = "Units"
        }
    }
}

extension UnitsOfSize {

    public var shortName: String {

        switch (self) {
            case .gram:
                return Localization.Tools.Units.Gram.localized
            case .kilogram:
                return Localization.Tools.Units.Kilogram.localized
            case .milliliter:
                return Localization.Tools.Units.Milliliter.localized
            case .liter:
                return Localization.Tools.Units.Liter.localized
            case .units:
                return Localization.Tools.Units.Units.localized
        }
    }
}
