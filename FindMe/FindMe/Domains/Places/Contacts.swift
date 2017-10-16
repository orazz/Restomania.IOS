//
//  Contacts.swift
//  FindMe
//
//  Created by Алексей on 19.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class Contacts: BaseDataType, IPlaceDependent, ICopying {
    
    public struct Keys {
        
        public static let placeId = "PlaceID"

        public static let email = "Email"
        public static let phone = "Phone"
        public static let secondPhone = "SecondPhone"
        public static let website = "Website"
        public static let instagram = "Instagram"
        public static let whatsapp = "Whatsapp"
        public static let viber = "Viber"
        public static let vk = "Vk"
        public static let facebook = "Facebook"
    }
    
    //MARK: IPlaceDependent
    public var placeId: Long

    public var email: String
    public var phone: String
    public var secondPhone: String
    public var website: String
    public var instagram: String
    public var whatsapp: String
    public var viber: String
    public var vk: String
    public var facebook: String
    
    public override init() {
        
        self.placeId = 0

        self.email = String.empty
        self.phone = String.empty
        self.secondPhone = String.empty
        self.website = String.empty
        self.instagram = String.empty
        self.whatsapp = String.empty
        self.viber = String.empty
        self.vk  = String.empty
        self.facebook = String.empty
        
        super.init()
    }
    
    //MARK: ICopyng
    public required init(source: Contacts) {
        
        self.placeId = source.placeId

        self.email = source.email
        self.phone = source.phone
        self.secondPhone = source.secondPhone
        self.website = source.website
        self.instagram = source.instagram
        self.whatsapp = source.whatsapp
        self.viber = source.viber
        self.vk = source.vk
        self.facebook = source.facebook
        
        super.init(source: source)
    }
    
    //MARK: Glossy
    public required init(json: JSON) {
        
        self.placeId = (Keys.placeId <~~ json)!

        self.email = (Keys.email <~~ json) ?? String.empty
        self.phone = (Keys.phone <~~ json) ?? String.empty
        self.secondPhone = (Keys.secondPhone <~~ json) ?? String.empty
        self.website = (Keys.website <~~ json)!
        self.instagram = (Keys.instagram <~~ json)!
        self.whatsapp = (Keys.whatsapp <~~ json)!
        self.viber = (Keys.viber <~~ json)!
        self.vk = (Keys.vk <~~ json)!
        self.facebook = (Keys.facebook <~~ json)!
        
        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        
        return jsonify([
            
            Keys.placeId ~~> self.placeId,

            Keys.email ~~> self.email,
            Keys.phone ~~> self.phone,
            Keys.secondPhone ~~> self.secondPhone,
            Keys.website ~~> self.website,
            Keys.instagram ~~> self.instagram,
            Keys.whatsapp ~~> self.whatsapp,
            Keys.viber ~~> self.viber,
            Keys.vk ~~> self.vk,
            Keys.facebook ~~> self.facebook,
            
            super.toJSON()
            ])
    }
}
