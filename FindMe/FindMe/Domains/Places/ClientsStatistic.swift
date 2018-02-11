//
//  ClientsData.swift
//  FindMe
//
//  Created by Алексей on 19.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import Gloss

public class ClientsStatistic: BaseDataType, IPlaceDependent, ICopying {
    
    public struct Keys {
        
        public static let placeId = "PlaceID"
        
        public static let people = "People"
        public static let males = "Males"
        public static let females = "Females"
        
        public static let averageAge = "AverageAge"
        public static let malesForAcquaintance = "MalesForAcquaintance"
        public static let femalesForAcquaintance = "FemalesForAcquaintance"
    }
    
    //MARK: IPlaceDependent
    public let placeId: Long
    
    public let people: Long
    public let males: Long
    public let females: Long
    public let averageAge: Double
    public let malesForAcquaintance: Int
    public let femalesForAcquaintance: Int
    
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
    public required init(source: ClientsStatistic) {
        
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
        self.males = (Keys.males <~~ json)!
        self.females = (Keys.females <~~ json)!
        self.malesForAcquaintance = (Keys.malesForAcquaintance <~~ json)!
        self.femalesForAcquaintance = (Keys.femalesForAcquaintance <~~ json)!
        
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
