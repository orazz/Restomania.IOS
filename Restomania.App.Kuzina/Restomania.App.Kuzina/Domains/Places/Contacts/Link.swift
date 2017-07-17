//
//  Link.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class Link: BaseDataType {
    public var `Type`:LinkType
    public var Url: String

    public override init() {
        self.Type = .Other
        self.Url = String.Empty

        super.init()
    }
    public required init(json: JSON) {
        self.Type = ("Type" <~~ json)!
        self.Url = ("Url" <~~ json)!

        super.init(json: json)
    }
}
