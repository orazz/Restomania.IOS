//
//  RemoteBugReport.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import IOSLibrary

public class RemoteBugReport: BaseBugReport {
    public var Log: String

    public override init() {
        self.Log = String.empty

        super.init()
    }
    public required init(json: JSON) {
        self.Log = ("Log" <~~ json)!

        super.init(json: json)
    }
}
