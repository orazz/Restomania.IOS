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

        super.init()

        self.backgroundColor = ThemeSettings.Colors.background
        self.attributedTitle = NSAttributedString(string: Localization.UIElements.RefreshControl.title)
        self.addTarget(target, action: action, for: .valueChanged)
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
extension UITableView {

    public func addRefreshControl(for target: Any, action: Selector) -> RefreshControl {

        let control = RefreshControl.init(target, action: action)
        self.addSubview(control)

        return control
    }
}
