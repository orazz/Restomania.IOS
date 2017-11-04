//
//  AuthContainer.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public struct AuthContainer {

    public let login: String
    public let password: String
    public let rights: AccessRights

    public init(login: String, password: String, rights: AccessRights = AccessRights.User) {

        self.login = login
        self.password = password
        self.rights = rights
    }
}
