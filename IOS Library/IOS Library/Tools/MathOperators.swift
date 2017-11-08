//
//  MathOperators.swift
//  IOSLibrary
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

extension Double {
    public static func *(left: Double, right: Int) -> Double {
        return left * Double(right)
    }
}
