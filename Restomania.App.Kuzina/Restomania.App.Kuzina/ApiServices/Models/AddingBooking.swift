//
//  AddingBooking.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public class AddingBooking {

    public var PlaceID: Int64
    public var CompleteDate: Date
    public var Comment: String
    public var PersonCount: Int

    public init() {
        self.PlaceID = 0
        self.CompleteDate = Date()
        self.Comment = String.empty
        self.PersonCount = 1
    }
}
