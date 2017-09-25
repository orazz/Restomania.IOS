//
//  ServicesFactory.swift
//  FindMe
//
//  Created by Алексей on 24.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public class ServicesFactory {
    
    public static let shared = ServicesFactory()
    
    public let keysStorage: IKeysStorage
    
    private init() {
        
        keysStorage = KeysStorage()
    }
}
