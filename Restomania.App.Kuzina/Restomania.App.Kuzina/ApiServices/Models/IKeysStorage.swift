//
//  IKeysStorage.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public protocol IKeysStorage {

    func keysFor(rights: AccessRights) -> AccessKeys?
    func logout(for: AccessRights)
}
