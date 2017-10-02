//
//  String.swift
//  IOS Library
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

extension String {
    public static var empty: String {
        return ""
    }
    public static func isNullOrEmpty(_ value: String?) -> Bool {
        return value == "" || value == nil
    }
    public static func tag(_ type: Any) -> String {
        return String(describing: Swift.type(of: type))
    }

}
