//
//  SizeLabel.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

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

            let integer = Int(floor(size))
            let float = size - Double(integer)

            if (float < 0.0001) {
                return "\(integer) \(units.shortName)"
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
            self.text = String(format: Localization.UIElements.WeightLabel.startFrom, text)

        } else {
            self.text = text
        }
    }
    public func clear() {
        self.text = String.empty
    }
}
