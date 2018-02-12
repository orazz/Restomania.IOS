//
//  Day.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class Day: BaseDataType {

    public var Open: Int
    public var Close: Int

    public override init() {
        self.Open = -1
        self.Close = -1

        super.init()
    }
    public required init(json: JSON) {
        self.Open = ("Open" <~~ json)!
        self.Close = ("Close" <~~ json)!

        super.init(json: json)
    }
}
