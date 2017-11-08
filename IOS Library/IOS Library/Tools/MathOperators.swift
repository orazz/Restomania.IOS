//
//  MathOperators.swift
//  IOSLibrary
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    public static func *(left: Double, right: Int) -> Double {
        return left * Double(right)
    }
}
extension CGFloat {
    public static func *(left: CGFloat, right: Int) -> CGFloat {
        return left * CGFloat(right)
    }
}
