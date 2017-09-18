//
//  BaseOrder.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import IOSLibrary

public class BaseOrder: BaseDataType {

    public var Summary: OrderSummary

    public override init() {
        self.Summary = OrderSummary()

        super.init()
    }
    public required init(json: JSON) {
        self.Summary = ("Summary" <~~ json)!

        super.init(json: json)
    }
}
