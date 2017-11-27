//
//  Place.swift
//  FindMe
//
//  Created by Алексей on 19.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class Place: BaseDataType, ICached {
    
    public struct Keys {

        public static let name = "Name"
        public static let type = "Type"
        public static let description = "Description"
        public static let status = "Status"
        public static let seatingCapacity = "SeatingCapacity"
        public static let timeZone = "TimeZone"
        
        public static let images = "Images"
        public static let actions = "Actions"
        
        public static let locationId = "LocationID"
        public static let location = "Location"
        public static let contactsId = "ContactsID"
        public static let contacts = "Contacts"
        public static let clientsDataId = "ClientsDataID"
        public static let clientsData = "ClientsData"
    }

    public var name: String
    public var type: String
    public var description: String
    public var status: PlaceStatus
    public var seatingCapacity: Int
    //public var timeZone: TimeZoneOffset
    
    public var images: [PlaceImage]
    public var actions: [Action]
    
    public var locationId: Long
    public var location: Location
    public var contactsId: Long
    public var contacts: Contacts
    public var clientsDataId: Long
    public var clientsData: ClientsStatistic
    
    //MARK: ICopyng
    public required init(source: Place) {

        self.name = source.name
        self.type = source.type
        self.description = source.description
        self.status = source.status
        self.seatingCapacity = source.seatingCapacity
        
        self.images = source.images.map({ PlaceImage(source: $0) })
        self.actions = source.actions.map({ Action(source: $0) })
        
        self.locationId = source.locationId
        self.location = Location(source: source.location)
        self.contactsId = source.contactsId
        self.contacts = Contacts(source: source.contacts)
        self.clientsDataId = source.clientsDataId
        self.clientsData = ClientsStatistic(source: source.clientsData)
        
        super.init(source: source)
    }
    
    //MARK: Glossy
    public required init(json: JSON) {

        self.name = (Keys.name <~~ json)!
        self.type = (Keys.type <~~ json)!
        self.description = (Keys.description <~~ json)!
        self.status = (Keys.status <~~ json)!
        self.seatingCapacity = (Keys.seatingCapacity <~~ json)!
        
        self.images = (Keys.images <~~ json)!
        self.actions = (Keys.actions <~~ json)!
        
        self.locationId = (Keys.locationId <~~ json)!
        self.location = (Keys.location <~~ json)!
        self.contactsId = (Keys.contactsId <~~ json)!
        self.contacts = (Keys.contacts <~~ json)!
        self.clientsDataId = (Keys.clientsDataId <~~ json)!
        self.clientsData = (Keys.clientsData <~~ json)!
        
        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([
            Keys.name ~~> self.name,
            Keys.type ~~> self.type,
            Keys.description ~~> self.description,
            Keys.status ~~> self.status,
            Keys.seatingCapacity ~~> self.seatingCapacity,

            Keys.images ~~> self.images,
            Keys.actions ~~> self.actions,

            Keys.locationId ~~> self.locationId,
            Keys.location ~~> self.location,
            Keys.contactsId ~~> self.contactsId,
            Keys.contacts ~~> self.contacts,
            Keys.clientsDataId ~~> self.clientsDataId,
            Keys.clientsData ~~> self.clientsData,
            ])
    }
}
