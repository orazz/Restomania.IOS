//
//  File.swift
//  UITools
//
//  Created by Алексей on 20.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public protocol ThemeColors {

    var defaultStatusBar: UIStatusBarStyle { get }

    var navigationMain: UIColor { get }
    var navigationContent: UIColor { get }

    var actionMain: UIColor { get }
    var actionDisabled: UIColor { get }
    var actionContent: UIColor { get }

    var notificationMain: UIColor { get }
    var notificationContent: UIColor { get }

    var contentBackground: UIColor { get }
    var contentBackgroundText: UIColor { get }
    var contentDivider: UIColor { get }
    var contentDividerText: UIColor { get }
    var contentSelection: UIColor { get }
    var contentTempText: UIColor { get }
}
