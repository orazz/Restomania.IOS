//
//  RefreshControl.swift
//  FindMe
//
//  Created by Алексей on 24.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {

    public func addRefreshControl(target: Any, selector: Selector) -> UIRefreshControl {

        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = ThemeSettings.Colors.background
        refreshControl.tintColor = ThemeSettings.Colors.main
        refreshControl.addTarget(target, action: selector, for: .valueChanged)

        let attributes = [NSAttributedStringKey.foregroundColor: ThemeSettings.Colors.main,
                                      NSAttributedStringKey.font: ThemeSettings.Fonts.default(size: .subhead)]
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните для обновления", attributes: attributes)

        self.addSubview(refreshControl)

        return refreshControl
    }
}
