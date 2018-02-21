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

    var iconCheckmark: UIImage { get }
    var iconCloseOnFilter: UIImage { get }
    var iconCloseOnContent: UIImage { get }
    var iconInfo: UIImage { get }
    var iconMinus: UIImage { get }
    var iconPlus: UIImage { get }
    var iconBack: UIImage { get }
    var iconForward: UIImage { get }

    var tabSearch: UIImage { get }
    var tabMap: UIImage { get }
    var tabManager: UIImage { get }

    var toolsLogo: UIImage { get }
    var toolsDefaultImage: UIImage { get }
    var toolsBottomGradient: UIImage { get }
    var toolsTopGradient: UIImage { get }
    var toolsDarkFilter: UIImage { get }
}
