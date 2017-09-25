//
//  Account.swift
//  FindMe
//
//  Created by Алексей on 18.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class Account: BaseDataType {
    
    public struct Keys {
        
        public static let name = "Name"
    }
    
    public var name: String
    
    public override init() {
        
        self.name = String.empty
        
        super.init()
    }
    
    //MARK: Glossy
    public required init(json: JSON) {
        
        self.name = (Keys.name <~~ json)!
        
        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        
        return jsonify([
            
            Keys.name ~~> self.name,
            
            super.toJSON()
            ])
    }
}
