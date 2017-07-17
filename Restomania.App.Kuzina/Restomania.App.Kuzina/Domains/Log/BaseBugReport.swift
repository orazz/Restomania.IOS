//
//  BaseBugReport.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class BaseBugReport: BaseDataType {
    public var Tag: String
    public var Description: String
    public var ExceptionName: String
    public var StackTrace: String
    public var `Type`: ReportType

    public override init() {
        self.Tag = String.Empty
        self.Description = String.Empty
        self.ExceptionName = String.Empty
        self.StackTrace = String.Empty
        self.Type = .App

        super.init()
    }
    public required init(json: JSON) {
        self.Tag = ("Tag" <~~ json)!
        self.Description = ("Description" <~~ json)!
        self.ExceptionName = ("ExceptionName" <~~ json)!
        self.StackTrace = ("StackTrace" <~~ json)!
        self.Type = ("Type" <~~ json)!

        super.init(json: json)
    }
}
