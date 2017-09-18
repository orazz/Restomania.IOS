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

public class PlaceImage: BaseDataType, IPlaceDependent, ICached, ISortable  {
    
    public struct Keys {
        
        public static let placeId = "PlaceID"
        public static let orderNumber = "OrderNumber"
        public static let link = "Link"
        public static let comment = "Comment"
    }
    
    //MARK: IPlaceDependent
    public var placeId: Long
    //MARK: ISortable
    public var orderNumber: Int
    
    public var link: String
    public var comment: String
    
    //MARK: ICopying
    public required init(source: PlaceImage) {
        
        self.placeId = source.placeId
        self.orderNumber = source.orderNumber
        self.link = source.link
        self.comment = source.comment
        
        super.init(source: source)
    }
    
    //MARK: Glossy
    public required init(json: JSON) {
        
        self.placeId = (Keys.placeId <~~ json)!
        self.orderNumber = (Keys.orderNumber <~~ json)!
        self.link = (Keys.link <~~ json)!
        self.comment = (Keys.comment <~~ json)!
        
        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        
        return jsonify([
            
            Keys.placeId ~~> self.placeId,
            Keys.orderNumber ~~> self.orderNumber,
            Keys.link ~~> self.link,
            Keys.comment ~~> self.comment,
            
            super.toJSON()
            ])
    }
}
