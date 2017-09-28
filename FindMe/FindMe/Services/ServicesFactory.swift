//
//  ServicesFactory.swift
//  FindMe
//
//  Created by Алексей on 24.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class ServicesFactory {
    
    public static let shared = ServicesFactory()

    //MARK: Base services
    public let configs: ConfigsStorage
    public let properties: PropertiesStorage<PropertiesKey>

    //MARK: Storage services
    public let keysStorage: IKeysStorage
    public let likes: LikesService

    //MARk: Cache services
    public let searchCards: SearchPlaceCardsCacheService
    
    private init() {

        configs = ConfigsStorage(plistName: "Configs.plist")
        properties = PropertiesStorage<PropertiesKey>()

        keysStorage = KeysStorage()
        likes = LikesService()

        searchCards = SearchPlaceCardsCacheService(properties: properties)
    }
}
