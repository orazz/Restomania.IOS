//
//  AppClientType.swift
//  Kuzina
//
//  Created by Алексей on 23.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public enum AppUserRole: String {

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
