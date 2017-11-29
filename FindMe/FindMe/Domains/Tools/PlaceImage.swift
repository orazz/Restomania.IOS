//
//  PlaceImage.swift
//  FindMe
//
//  Created by Алексей on 18.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class PlaceImage: Attachment, IPlaceDependent, ICached, ISortable  {
    
    public struct Keys {
        
        public static let placeId = "PlaceID"
        public static let orderNumber = "OrderNumber"
    }
    
    //MARK: IPlaceDependent
    public let placeId: Long
    //MARK: ISortable
    public let orderNumber: Int

    public override init() {

        self.placeId = 0
        self.orderNumber = 0

        super.init()
    }

    //MARK: ICopying
    public required init(source: PlaceImage) {
        
        self.placeId = source.placeId
        self.orderNumber = source.orderNumber
        
        super.init(source: source)
    }
    
    //MARK: Glossy
    public required init(json: JSON) {
        
        self.placeId = (Keys.placeId <~~ json)!
        self.orderNumber = (Keys.orderNumber <~~ json)!
        
        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        
        return jsonify([
            
            Keys.placeId ~~> self.placeId,
            Keys.orderNumber ~~> self.orderNumber,
            
            super.toJSON()
            ])
    }
}
