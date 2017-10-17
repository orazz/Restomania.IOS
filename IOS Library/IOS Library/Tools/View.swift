//
//  View.swift
//  IOSLibrary
//
//  Created by Алексей on 17.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    public func getConstant(_ type: NSLayoutAttribute) -> CGFloat? {

        return self.constraints.filter({ $0.firstAttribute == type }).first?.constant
    }
    public func getParentConstant(_ type: NSLayoutAttribute) -> CGFloat? {

        return self.superview?.constraints.filter({ $0.firstAttribute == type }).first?.constant
    }
    public func setContraint(height: CGFloat) {

        setContraint(.height, to: height)
    }
    public func setContraint(width: CGFloat) {

        setContraint(.width, to: width)
    }
    public func setContraint(_ type:NSLayoutAttribute, to value: CGFloat) {

        for contraint in self.constraints {
            if (contraint.firstAttribute == type) {
                contraint.constant = value
                return
            }
        }
    }
}
