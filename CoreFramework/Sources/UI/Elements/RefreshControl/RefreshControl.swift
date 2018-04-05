//
//  RefreshControl.swift
//  CoreFramework
//
//  Created by Алексей on 19.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class RefreshControl: UIRefreshControl {

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    public init(_ target: Any, action: Selector) {

        super.init()

        self.backgroundColor = themeColors.contentBackground
        let attributes = [
            NSAttributedStringKey.foregroundColor: themeColors.contentText,
            NSAttributedStringKey.font: themeFonts.default(size: .caption)
            ]
        self.attributedTitle = NSAttributedString(string: Localization.title.localized, attributes: attributes)
        self.tintColor = themeColors.contentText
        self.backgroundColor = themeColors.contentBackground
        
        self.addTarget(target, action: action, for: .valueChanged)
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
extension UIScrollView {

    public func addRefreshControl(for target: Any, action: Selector) -> RefreshControl {

        let control = RefreshControl.init(target, action: action)
        self.addSubview(control)

        return control
    }
}
extension RefreshControl {
    public enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(RefreshControl.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        case title = "Title"
    }
}
