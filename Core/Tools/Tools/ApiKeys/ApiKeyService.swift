//
//  ApiKeyService.swift
//  CoreTools
//
//  Created by Алексей on 13.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation

public protocol ApiKeyService {

    var isAuth: Bool { get }
    var role: ApiRole { get }
    var keys: ApiKeys? { get }

    func update(by keys: ApiKeys)
    func logout()
}
