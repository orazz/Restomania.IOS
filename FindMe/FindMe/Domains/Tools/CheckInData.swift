//
//  CheckInData.swift
//  FindMe
//
//  Created by Алексей on 18.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class CheckInData: BaseDataType {
    
    public struct Keys {
        
        public static let placeId = "PlaceID"
        public static let userId = "UserID"
        public static let expirationTime = "ExpirationTime"
    }
    
    public let placeId: Long
    public let userId: Long
    public let expirationTime: Date
    
    public override init() {
        
        self.placeId = 0
        self.userId = 0
        self.expirationTime = Date()
        
        super.init()
    }
    
    //MARK: Glossy
    public required init(json: JSON) {
        
        self.placeId = (Keys.placeId <~~ json)!
        self.userId = (Keys.userId <~~ json)!
        
        let expirationTime: String = (Keys.expirationTime <~~ json)!
        self.expirationTime = Date.parseJson(value: expirationTime)
        
        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        
        return jsonify([
            
            Keys.placeId ~~> self.placeId,
            Keys.userId ~~> self.userId,
            Keys.expirationTime ~~> self.expirationTime.prepareForJson(),
            
            super.toJSON()
            ])
    }
}
