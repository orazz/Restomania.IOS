//
//  Location.swift
//  FindMe
//
//  Created by Алексей on 19.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class Location: BaseDataType, IPlaceDependent, ICopying {
    
    public struct Keys {
        
        public static let placeId = "PlaceID"
        
        public static let latitude = "Latitude"
        public static let longitude = "Longitude"
        public static let address = "Address"
        public static let city = "City"
        public static let metro = "Metro"
        public static let borough = "Borough"
    }
    
    public var placeId: Long
    
    public var latitude: Double
    public var longitude: Double
    public var address: String
    public var city: String
    public var metro: String
    public var borough: String
    
    public override init() {
        
        self.placeId = 0
        
        self.latitude = 0.0
        self.longitude = 0.0
        self.address = String.empty
        self.city = String.empty
        self.metro = String.empty
        self.borough = String.empty
        
        super.init()
    }
    
    //MARK: ICopyng
    public required init(source: Location) {
        
        self.placeId = source.placeId
        
        self.latitude = source.latitude
        self.longitude = source.longitude
        self.address = source.address
        self.city = source.city
        self.metro = source.metro
        self.borough = source.borough
        
        super.init(source: source)
    }
    
    //MARK: Glossy
    public required init(json: JSON) {
        
        self.placeId = (Keys.placeId <~~ json)!
        
        self.latitude = (Keys.latitude <~~ json)!
        self.longitude = (Keys.longitude <~~ json)!
        self.address = (Keys.address <~~ json)!
        self.city = (Keys.city <~~ json)!
        self.metro = (Keys.metro <~~ json)!
        self.borough = (Keys.borough <~~ json)!
        
        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        
        return jsonify([
            
            Keys.placeId ~~> self.placeId,
            Keys.latitude ~~> self.latitude,
            Keys.longitude ~~> self.longitude,
            Keys.address ~~> self.address,
            Keys.city ~~> self.city,
            Keys.metro ~~> self.metro,
            Keys.borough ~~> self.borough,
            
            super.toJSON()
            ])
    }
}
