//
//  Banner.swift
//  UIElements
//
//  Created by Алексей on 22.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import NotificationBannerSwift

open class BannerAlert {

    private let source: NotificationBanner
    private let theme = DependencyResolver.get(ThemeColors.self)

    public init(title: String, subtitle: String) {

        source = NotificationBanner(title: title, subtitle: subtitle, colors: theme.bannerColors)
    }

    //Actions
    public var onTap: Trigger? {
        get {
            return source.onTap
        }
        set {
            source.onTap = newValue
        }
    }
    public var onSwipeUp: Trigger? {
        get {
            return source.onSwipeUp
        }
        set {
            source.onSwipeUp = newValue
        }
    }

    public func show() {
        source.show()
    }
}
