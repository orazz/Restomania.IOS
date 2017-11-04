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
    public static let configs = ConfigsStorage(plistName: "Configs")
    public var configs: ConfigsStorage {
        return ServicesFactory.configs
    }
    public let properties: PropertiesStorage<PropertiesKey>
    public let tasksService: BackgroundTasksService

    //MARk: Cache services
    public static let keys: IKeysStorage = KeysStorage()
    public var keys: IKeysStorage {
        return ServicesFactory.keys
    }
    public let images: CacheImagesService
    public let searchCards: SearchPlaceCardsCacheService
    public let likes: LikesService
    public let places: PlacesCacheservice

    //MARK: Storage services
    public let positions: PositionsService
    public let backgroundPositions: BackgroundPositionsServices
    public let checkIns: CheckInService


    private init() {

        properties = PropertiesStorage<PropertiesKey>()
        tasksService = BackgroundTasksService.shared

        images = CacheImagesService()
        searchCards = SearchPlaceCardsCacheService(configs: ServicesFactory.configs,
                                                    properties: properties)
        likes = LikesService()
        places = PlacesCacheservice(configs: ServicesFactory.configs,
                                    properties: properties)

        positions = PositionsService()
        backgroundPositions = BackgroundPositionsServices(tasksService: tasksService)
        checkIns = CheckInService(positions: positions,
                                  backgroundPositions: backgroundPositions,
                                  searchCards: searchCards,
                                  configs: ServicesFactory.configs,
                                  keys: ServicesFactory.keys)
    }
}
