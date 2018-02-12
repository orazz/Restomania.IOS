//
//  StringApiRole.swift
//  CoreTools
//
//  Created by Алексей on 12.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import CoreDomains

internal enum StringApiRole: String {

    case user = "User"
    case place = "Place"
    case admin = "Admin"

    public var role: ApiRole {
        switch self {
        case .place:
            return .place
        case .admin:
            return .admin
        default:
            return .user
        }
    }
}
