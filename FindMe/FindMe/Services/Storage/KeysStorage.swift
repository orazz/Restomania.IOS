//
//  IKeysStorage.swift
//  FindMe
//
//  Created by Алексей on 24.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

internal class KeysStorage: IKeysStorage {
    
    public init() {
        
    }
    
    
    //MARK: IKeysStorage
    public func keys(for rights: ApiRights) -> OptionalValue<ApiKeys> {
        
        return OptionalValue(nil)
    }
}
