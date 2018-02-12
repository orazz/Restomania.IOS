//
//  Step.swift
//  Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class Step: BaseDataType {

    public var Sum: Double
    public var Percent: Double

    public override init() {
        self.Sum = 0
        self.Percent = 0

        super.init()
    }
    public required init(json: JSON) {
        self.Sum = ("Sum" <~~ json)!
        self.Percent = ("Percent" <~~ json)!

        super.init(json: json)
    }
}
