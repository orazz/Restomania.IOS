//
//  ApiKeyServiceDelegate.swift
//  CoreTools
//
//  Created by Алексей on 13.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation

public protocol ApiKeyServiceDelegate {

    func apiKeyService(_ service: ApiKeyService, update keys: ApiKeys, for role: ApiRole)
    func apiKeyService(_ service: ApiKeyService, logout role: ApiRole)
}

extension ApiKeyServiceDelegate {
    
    public func apiKeyService(_ service: ApiKeyService, update keys: ApiKeys, for role: ApiRole) {}
    public func apiKeyService(_ service: ApiKeyService, logout role: ApiRole) {}
}
