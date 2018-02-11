//
//  String.swift
//  MdsKit
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

//Technical tools
extension String {
    public static var empty: String {
        return ""
    }
    public static func isNullOrEmpty(_ value: String?) -> Bool {
        return value == "" || value == nil
    }
    public static func tag(_ type: Any) -> String {
        
        let type =  String(describing: Swift.type(of: type))

        return type.components(separatedBy: ".").first!
    }
}

//MARK: Localization
public protocol Localizable {
    var tableName: String { get }
    var localized: String { get }
}
extension String {

    public var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    public func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}
extension Localizable where Self: RawRepresentable,
                             Self.RawValue == String {

    public var localized: String {
        return rawValue.localized(tableName: tableName)
    }
}

//UI Elements
extension String {
    public func height(containerWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    public func width(containerHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}
