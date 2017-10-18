//
//  Switch.swift
//  IOSLibrary
//
//  Created by Алексей on 19.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

extension UISwitch {

    open func toogle(animated: Bool = false) {

        self.setOn(!self.isOn, animated: animated)
    }
}
