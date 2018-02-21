//
//  ThemeImages.swift
//  UITools
//
//  Created by Алексей on 22.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public protocol ThemeImages {

    var logo: UIImage { get }
    var `default`: UIImage { get }
    var navigationBackward: UIImage { get }
    var icon: UIImage { get }
}
