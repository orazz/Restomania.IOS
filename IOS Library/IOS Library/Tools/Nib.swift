//
//  Nib.swift
//  IOSLibrary
//
//  Created by Алексей on 13.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

extension UINib {
    open static func instantiate<TView>(from nibName: String, bundle: Bundle) -> TView {

        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: nil, options: nil).first! as! TView
    }
}
