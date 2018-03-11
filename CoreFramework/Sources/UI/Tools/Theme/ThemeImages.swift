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
    var tabFavourite: UIImage { get }
    var tabMenu: UIImage { get }
    var tabInfo: UIImage { get }
    var tabOrders: UIImage { get }
    var tabsOther: UIImage { get }

    var toolsLogo: UIImage { get }
    var toolsDefaultImage: UIImage { get }
    var toolsBottomGradient: UIImage { get }
    var toolsTopGradient: UIImage { get }
    var toolsFilterDark: UIImage { get }
}
extension ThemeImages {
    public var iconCheckmark: UIImage {
        return loadAssert("icon-checkmark")
    }
    public var iconCloseOnFilter: UIImage {
        return loadAssert("icon-close-on-filter")
    }
    public var iconCloseOnContent: UIImage {
        return loadAssert("icon-close-on-content")
    }
    public var iconInfo: UIImage {
        return loadAssert("icon-info")
    }
    public var iconMinus: UIImage {
        return loadAssert("icon-minus")
    }
    public var iconPlus: UIImage {
        return loadAssert("icon-plus")
    }
    public var iconBack: UIImage {
        return loadAssert("icon-backward")
    }
    public var iconForward: UIImage {
        return loadAssert("icon-forward")
    }

    public var tabSearch: UIImage {
        return loadAssert("tab-search")
    }
    public var tabMap: UIImage {
        return loadAssert("tab-map")
    }
    public var tabFavourite: UIImage {
        return loadAssert("tab-favourite")
    }
    public var tabMenu: UIImage {
        return loadAssert("tab-menu")
    }
    public var tabInfo: UIImage {
        return loadAssert("tab-info")
    }
    public var tabOrders: UIImage {
        return loadAssert("tab-orders")
    }
    public var tabsOther: UIImage {
        return loadAssert("tab-other")
    }

    public var toolsLogo: UIImage {
        return loadAssert("tools-logo")
    }
    public var toolsDefaultImage: UIImage {
        return loadAssert("tools-default")
    }
    public var toolsBottomGradient: UIImage {
        return loadAssert("tools-gradient-bottom")
    }
    public var toolsTopGradient: UIImage {
        return loadAssert("tools-gradient-top")
    }
    public var toolsFilterDark: UIImage {
        return loadAssert("tools-filter-dark")
    }

    private func loadAssert(_ name: String) -> UIImage {
        return UIImage(named: name, in: Bundle.coreFramework, compatibleWith: nil)!
    }
}
