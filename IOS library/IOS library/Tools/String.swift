//
//  String.swift
//  IOS Library
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

extension String {
    public static var Empty: String {
        return ""
    }
    public static func IsNullOrEmpty(_ value: String?) -> Bool {
        return value != "" && value != nil
    }
}
