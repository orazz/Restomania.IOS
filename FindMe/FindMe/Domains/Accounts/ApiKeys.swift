//
//  ApiKeys.swift
//  FindMe
//
//  Created by Алексей on 18.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class ApiKeys: Glossy {
    
    public struct Keys {
        
        public static let id = "ID"
        public static let token = "Token"
    }
    
    public var id: Long
    public var token: String

    public init(id: Long, token: String) {
        self.id = id
        self.token = token
    }
    
    //MARK: Glossy
    public required init(json: JSON) {
        
        self.id = (Keys.id <~~ json)!
        self.token = (Keys.token <~~ json)!
    }
    public func toJSON() -> JSON? {
        
        return jsonify([
            
            Keys.id ~~> self.id,
            Keys.token ~~> self.token,
            ])
    }
}
