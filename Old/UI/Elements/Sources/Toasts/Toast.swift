//
//  Toast.swift
//  UIElements
//
//  Created by Алексей on 04.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import Toast_Swift

open class Toast {

}
extension UIViewController {
    open func showToast(_ message: Localizable, complettion: ((Bool) -> Void)? = nil) {
        self.showToast(message.localized, completion: complettion)
    }
    open func showToast(_ message: String, completion: ((Bool) -> Void)? = nil) {
        self.view.makeToast(message, completion: completion)
    }
}
