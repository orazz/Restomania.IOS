//
//  AuthContainer.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public class AuthContainer {

    public let login: String
    public let password: String
    public let role: ApiRole

    public convenience init() {
        self.init(login: String.empty, password: String.empty)
    }
    public convenience init(rights: ApiRole) {
        self.init(login: String.empty, password: String.empty, rights: rights)
    }
    public init(login: String, password: String, rights: ApiRole = ApiRole.user) {

        self.login = login
        self.password = password
        self.role = rights
    }
}
