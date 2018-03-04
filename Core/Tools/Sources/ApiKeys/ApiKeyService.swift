//
//  ApiKeyService.swift
//  CoreTools
//
//  Created by Алексей on 13.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public protocol ApiKeyService {
    
    var role: ApiRole { get }
    var keys: ApiKeys? { get }

    func update(by keys: ApiKeys)
    func logout()


    func subscribe(guid: String, handler: ApiKeyServiceDelegate, tag: String)
    func unsubscribe(guid: String)
}
extension ApiKeyService {

    public var isAuth: Bool {
        return nil != keys
    }
}
