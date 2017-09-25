//
//  Action.swift
//  FindMe
//
//  Created by Алексей on 19.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class Action: BaseDataType, IPlaceDependent, ISortable, ICopying {
    
    public struct Keys {
        
        public static let placeId = "PlaceID"
        public static let orderNumber = "OrderNumber"
        
        public static let name = "Name"
        public static let details = "Details"
        public static let image = "Image"
        public static let isHide = "IsHide"
    }
    
    //MARK: IPlaceDependent
    public var placeId: Long
    //MARK: ISortable
    public var orderNumber: Int
    
    public var name: String
    public var details: String
    public var image: Attachment
    public var isHide: Bool
    
    public override init() {
        
        self.placeId = 0
        self.orderNumber = 0;
        
        self.name = String.empty
        self.details = String.empty
        self.image = Attachment()
        self.isHide = true
        
        super.init()
    }
    
    //MARK: ICopyng
    public required init(source: Action) {
        
        self.placeId = source.placeId
        self.orderNumber = source.orderNumber
        
        self.name = source.name
        self.details = source.details
        self.image = Attachment(source: source.image)
        self.isHide = source.isHide
        
        super.init(source: source)
    }
    
    
    //MARK: Glossy
    public required init(json: JSON) {
        
        self.placeId = (Keys.placeId <~~ json)!
        self.orderNumber = (Keys.orderNumber <~~ json)!
        
        self.name = (Keys.name <~~ json)!
        self.details = (Keys.details <~~ json)!
        self.image = (Keys.image <~~ json)!
        self.isHide = (Keys.isHide <~~ json)!
        
        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        
        return jsonify([
            
            Keys.placeId ~~> self.placeId,
            Keys.orderNumber ~~> self.orderNumber,
            
            Keys.name ~~> self.name,
            Keys.details ~~> self.details,
            Keys.image ~~> self.image,
            Keys.isHide ~~> self.isHide,
            
            super.toJSON()
            ])
    }
}
