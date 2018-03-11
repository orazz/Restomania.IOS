//
//  AuthHandler.swift
//  UIServices
//
//  Created by Алексей on 10.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation

internal protocol AuthHandler {

    func complete(success: Bool, keys: ApiKeys?)
}
