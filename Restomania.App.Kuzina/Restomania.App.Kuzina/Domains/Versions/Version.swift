//
//  Version.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import IOSLibrary

public class Version : BaseDataType
{
    public var Number: String
    public var Platform: Platform
    public var Link: String
    public var Critical: Bool
    
    public override init()
    {
        self.Number = "1.0"
        self.Platform = .WP
        self.Link = String.Empty
        self.Critical = false
        
        super.init()
    }
    public required init(json: JSON)
    {
        self.Number = ("Number" <~~ json)!
        self.Platform = ("Platform" <~~ json)!
        self.Link = ("Link" <~~ json)!
        self.Critical = ("Critical" <~~ json)!
        
        super.init(json: json)
    }
}
