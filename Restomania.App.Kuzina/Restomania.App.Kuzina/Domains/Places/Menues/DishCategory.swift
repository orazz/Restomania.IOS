//
//  DishCategory.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class DishCategory: BaseDataType {
    public var Name: String
    public var ImageLink: String

    public override init() {
        self.Name = String.Empty
        self.ImageLink = String.Empty

        super.init()
    }
    public required init(json: JSON) {
        self.Name = ("Name" <~~ json)!
        self.ImageLink = ("ImageLink" <~~ json)!

        super.init(json: json)
    }
}
