//
//  BaseDataType.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 11.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Gloss
import Foundation

public class BaseDataType : Glossy
{
    public var ID:Int64 = 0
    public var CreateAt:Date
    public var UpdateAt:Date
    
    public init()
    {
        self.ID = 0
        self.CreateAt = Date()
        self.UpdateAt = Date()
    }
    public required convenience init(json: JSON)
    {
        self.init()
    }
    public func toJSON() -> JSON?
    {
        return nil
    }
}
