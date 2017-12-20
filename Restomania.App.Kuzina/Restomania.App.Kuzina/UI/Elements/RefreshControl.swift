//
//  RefreshControl.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 19.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class RefreshControl: UIRefreshControl {

    public init(_ target: Any, action: Selector) {

        self.backgroundColor = ThemeSettings.Colors.background
        self.attributedTitle = NSAttributedString(string: "Потяните для обновления")
        self.addTarget(target, action: action, for: .valueChanged)
    }
}
extension UITableView {

    public func addRefreshControl(for target: Any, action: Selector) {

    }
}
