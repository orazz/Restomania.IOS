//
//  Review.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class Review: BaseDataType {
    public var  UserID: Int64
    public  var PlaceID: Int64
    public var Rating: Rate
    public var Content: String
    public var Status: ReviewStatus
    public var UserName: String
    public var PlaceName: String

    public override init() {
        self.UserID = 0
        self.PlaceID = 0
        self.Rating = .Bad
        self.Content = String.Empty
        self.Status = .Processing
        self.UserName = String.Empty
        self.PlaceName = String.Empty

        super.init()
    }
    public required init(json: JSON) {
        self.UserID = ("UserID" <~~ json)!
        self.PlaceID = ("PlaceID" <~~ json)!
        self.Rating = ("Rating" <~~ json)!
        self.Content = ("Content" <~~ json)!
        self.Status = ("Status" <~~ json)!
        self.UserName = ("UserName" <~~ json)!
        self.PlaceName = ("PlaceName" <~~ json)!

        super.init(json: json)
    }
}
