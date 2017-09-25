//
//  Color.swift
//  IOS Library
//
//  Created by Алексей on 24.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    public convenience init(red: Float, green: Float, blue: Float) {

        self.init(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: CGFloat(1))
    }
}
