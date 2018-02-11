//
//  Attachment.swift
//  FindMe
//
//  Created by Алексей on 19.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import Gloss

public class Attachment: BaseDataType {
    
    public struct Keys {
        
        public static let link = "Link"
        public static let comment = "Comment"
    }
    
    public let link: String
    public let comment: String
    
    public override init() {
        
        self.link = String.empty
        self.comment = String.empty
        
        super.init()
    }
    
    //MARK: ICopyng
    public init(source: Attachment) {
        
        self.link = source.link
        self.comment = source.comment
        
        super.init(source: source)
    }
    
    //MARK: Glossy
    public required init(json: JSON) {
        
        self.link = (Keys.link <~~ json)!
        self.comment = (Keys.comment <~~ json)!
        
        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        
        return jsonify([
            
            Keys.link ~~> self.link,
            Keys.comment ~~> self.comment,
            
            super.toJSON()
            ])
    }
}
