//
//  IKeysStorage.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public protocol IKeysStorage {

    func isAuth(for rights: AccessRights) -> Bool
    func keys(for: AccessRights) -> AccessKeys?
    func logout(for: AccessRights)
}
