//
//  Tools.swift
//  UITools
//
//  Created by Алексей on 04.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

extension Bundle {

    public static var coreFramework: Bundle {
        return Bundle(identifier: "mds.mobile.restomania.app.core")!
    }
}
extension UINavigationController {

    public func setStatusBarStyle(from style: UIStatusBarStyle) {

        if (style == .default) {
            navigationBar.barStyle = .black
        }
        else {
            navigationBar.barStyle = .blackTranslucent
        }
    }
}
