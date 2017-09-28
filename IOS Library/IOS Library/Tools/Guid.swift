//
//  Guid.swift
//  IOS Library
//
//  Created by Алексей on 11.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public class Guid {
    
    public static var new: String {
        return UUID().uuidString
    }
}
