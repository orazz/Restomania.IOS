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
        public static let males = "Males"
        public static let females = "Females"
        
        public static let averageAge = "AverageAge"
        public static let malesForAcquaintance = "MalesForAcquaintance"
        public static let femalesForAcquaintance = "FemalesForAcquaintance"

        public static let men = "Men"
        public static let women = "Women"
        public static let menForAcquaintance = "MenForAcquaintance"
        public static let womenForAcquaintance = "WomenForAcquaintance"
    }
    
    //MARK: IPlaceDependent
    public var placeId: Long
    
    public var people: Long
    public var males: Long
    public var females: Long
    public var averageAge: Double
    public var malesForAcquaintance: Int
    public var femalesForAcquaintance: Int
    
    public override init() {
        
        self.placeId = 0
        
        self.people = 0
        self.males = 0
        self.females = 0
        self.averageAge = 0
        self.malesForAcquaintance = 0
        self.femalesForAcquaintance = 0
        
        super.init()
    }
    
    //MARK: ICopyng
    public required init(source: ClientsData) {
        
        self.placeId = source.placeId
        
        self.people = source.people
        self.males = source.males
        self.females = source.females
        self.averageAge = source.averageAge
        self.malesForAcquaintance = source.malesForAcquaintance
        self.femalesForAcquaintance = source.femalesForAcquaintance
        
        super.init(source: source)
    }
    
    //MARK: Glossy
    public required init(json: JSON) {
        
        self.placeId = (Keys.placeId <~~ json)!
        
        self.people = (Keys.people <~~ json)!
        self.averageAge = (Keys.averageAge <~~ json)!

        //Migration
        self.males = (Keys.males <~~ json) ?? (Keys.men <~~ json)!
        self.females = (Keys.females <~~ json) ?? (Keys.women <~~ json)!
        self.malesForAcquaintance = (Keys.malesForAcquaintance <~~ json) ?? (Keys.menForAcquaintance <~~ json)!
        self.femalesForAcquaintance = (Keys.femalesForAcquaintance <~~ json) ?? (Keys.womenForAcquaintance <~~ json)!
        
        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([
            Keys.placeId ~~> self.placeId,

            Keys.people ~~> self.people,
            Keys.males ~~> self.males,
            Keys.females ~~> self.females,

            Keys.averageAge ~~> self.averageAge,
            Keys.malesForAcquaintance ~~> self.malesForAcquaintance,
            Keys.femalesForAcquaintance ~~> self.femalesForAcquaintance,

            super.toJSON()
            ])
    }
}
