//
//  SizeLabel.swift
//  CoreFramework
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class SizeLabel: UILabel {

    //Data
    public private(set) var size = 0.0
    public private(set) var units = UnitsOfSize.units
    public private(set) var useStartFrom: Bool = false

    public override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }
    public required init(coder: NSCoder) {
        super.init(coder: coder)!

        initialize()
    }
    private func initialize() {
        clear()
    }

    public static func build(for size: Double, with units: UnitsOfSize) -> String {

        if (0.0 == size) {
            return String.empty
        } else {

            let decimal = Int(floor(size))
            let float = size - Double(decimal)

            if (float < 0.0001) {
                return "\(decimal) \(units.shortName)"
            } else {
                return "\(size) \(units.shortName)"
            }
        }
    }
    public func setup(size: Double, units: UnitsOfSize, useStartFrom: Bool = false) {

        self.size = size
        self.units = units
        self.useStartFrom = useStartFrom

        let text = SizeLabel.build(for: size, with: units)
        if (String.isNullOrEmpty(text)) {
            clear()

        } else if (useStartFrom) {
            self.text = String(format: Localization.startFrom.localized, text)

        } else {
            self.text = text
        }
    }
    public func clear() {
        self.text = String.empty
    }
}

extension SizeLabel {
    public enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(SizeLabel.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        case startFrom = "Formats.StartFrom"

        case Gram = "Units.Gram"
        case Kilogram = "Units.Kilogram"
        case Milliliter = "Units.Milliliter"
        case Liter = "Units.Liter"
        case Units = "Units"
    }
}

extension UnitsOfSize {

    public var shortName: String {

        switch (self) {
        case .gram:
            return SizeLabel.Localization.Gram.localized
        case .kilogram:
            return SizeLabel.Localization.Kilogram.localized
        case .milliliter:
            return SizeLabel.Localization.Milliliter.localized
        case .liter:
            return SizeLabel.Localization.Liter.localized
        case .units:
            return SizeLabel.Localization.Units.localized
        }
    }
}
