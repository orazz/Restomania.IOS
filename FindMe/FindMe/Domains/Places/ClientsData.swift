//
//  ClientsData.swift
//  FindMe
//
//  Created by Алексей on 19.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class ClientsData: BaseDataType, IPlaceDependent, ICopying {
    
    public struct Keys {
        
        public static let placeId = "PlaceID"
        
        public static let people = "People"
        public static let men = "Men"
        public static let women = "Women"
        
        public static let averageAge = "AverageAge"
        public static let menForAcquaintance = "MenForAcquaintance"
        public static let womenForAcquaintance = "WomenForAcquaintance"
    }
    
    //MARK: IPlaceDependent
    public var placeId: Long
    
    public var people: Long
    public var men: Long
    public var women: Long
    public var averageAge: Double
    public var menForAcquaintance: Int
    public var womenForAcquaintance: Int
    
    public override init() {
        
        self.placeId = 0
        
        self.people = 0
        self.men = 0
        self.women = 0
        self.averageAge = 0
        self.menForAcquaintance = 0
        self.womenForAcquaintance = 0
        
        super.init()
    }
    
    //MARK: ICopyng
    public required init(source: ClientsData) {
        
        self.placeId = source.placeId
        
        self.people = source.people
        self.men = source.men
        self.women = source.women
        self.averageAge = source.averageAge
        self.menForAcquaintance = source.menForAcquaintance
        self.womenForAcquaintance = source.womenForAcquaintance
        
        super.init(source: source)
    }
    
    //MARK: Glossy
    public required init(json: JSON) {
        
        self.placeId = (Keys.placeId <~~ json)!
        
        self.people = (Keys.people <~~ json)!
        self.men = (Keys.men <~~ json)!
        self.women = (Keys.women <~~ json)!
        self.averageAge = (Keys.averageAge <~~ json)!
        self.menForAcquaintance = (Keys.menForAcquaintance <~~ json)!
        self.womenForAcquaintance = (Keys.womenForAcquaintance <~~ json)!
        
        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([
            Keys.placeId ~~> self.placeId,

            Keys.people ~~> self.people,
            Keys.men ~~> self.men,
            Keys.women ~~> self.women,

            Keys.averageAge ~~> self.averageAge,
            Keys.menForAcquaintance ~~> self.menForAcquaintance,
            Keys.womenForAcquaintance ~~> self.womenForAcquaintance,

            super.toJSON()
            ])
    }
}
