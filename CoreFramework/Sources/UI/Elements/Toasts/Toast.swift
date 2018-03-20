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
    public enum Position: Int {
        case top = 1
        case middle = 2
        case bottom = 3

        fileprivate func convert() -> ToastPosition {

            switch self {
            case .top:
                return .top
            case .middle:
                return .center
            case .bottom:
                return .bottom
            }
        }
    }

}
extension UIViewController {
    open func showToast(_ message: Localizable, position: Toast.Position? = nil, complettion: ((Bool) -> Void)? = nil) {
        self.showToast(message.localized, position: position, completion: complettion)
    }
    open func showToast(_ message: String, position: Toast.Position? = nil, completion: ((Bool) -> Void)? = nil) {
        self.view.makeToast(message, position: position?.convert() ?? ToastManager.shared.position, completion: completion)
    }
}
