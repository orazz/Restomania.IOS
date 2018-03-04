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

    open func showToast(_ title: Localizable) {
        self.view.makeToast(title.localized)
    }
}
