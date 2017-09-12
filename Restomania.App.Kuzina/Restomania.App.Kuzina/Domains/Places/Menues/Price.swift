//
//  Price.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 12.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class PriceType: Glossy {

    public struct Keys {

        public static let decimal = "Decimal"
        public static let float = "Float"
    }

    public var decimal: Int
    public var float: Int

    public convenience init() {

        self.init(decimal: 0, float: 0)
    }
    public init(decimal: Int, float: Int) {

        self.decimal = decimal
        self.float = float
    }
    public init(double value: Double) {

        decimal = Int(floor(value))

        let diffent = value - Double(decimal)
        float = Int(round(diffent * 100))
    }

    public var double: Double {

        return Double(decimal) + Double(float)/100
    }

    // MARK: Glossy
    public required init?(json: JSON) {

        decimal = (Keys.decimal <~~ json)!
        float = (Keys.float <~~ json)!
    }
    public func toJSON() -> JSON? {

        return jsonify([

                Keys.decimal ~~> self.decimal,
                Keys.float ~~> self.float
            ])
    }
}
