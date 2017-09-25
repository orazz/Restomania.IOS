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
    public var clientsData: ClientsData
    
    //MARK: ICopyng
    public required init(source: Place) {
        
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
        self.clientsData = ClientsData(source: source.clientsData)
        
        super.init(source: source)
    }
    
    //MARK: Glossy
    public required init(json: JSON) {
        
        self.type = (Keys.type <~~ json)!
        self.description = (Keys.type <~~ json)!
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
}
