//
//  RefreshControl.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 19.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import Localization
import CoreTools
import UITools

public class RefreshControl: UIRefreshControl {

    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    public init(_ target: Any, action: Selector) {

        super.init()

        self.backgroundColor = themeColors.contentBackground
        let attributes = [
            NSAttributedStringKey.foregroundColor: themeColors.contentBackgroundText,
            NSAttributedStringKey.font: themeFonts.default(size: .subhead)
            ]
        self.attributedTitle = NSAttributedString(string: Localization.UIElements.RefreshControl.title, attributes: attributes)
        
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
