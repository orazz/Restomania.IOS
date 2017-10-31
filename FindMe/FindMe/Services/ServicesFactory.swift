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
    public let tasksService: BackgroundTasksService

    //MARk: Cache services
    public let keys: IKeysStorage
    public let images: CacheImagesService
    public let searchCards: SearchPlaceCardsCacheService
    public let likes: LikesService
    public let places: PlacesCacheservice

    //MARK: Storage services
    public let positions: PositionsService
    public let backgroundPositions: BackgroundPositionsServices
    public let checkIns: CheckInService


    private init() {

        configs = ConfigsStorage(plistName: "Configs")
        properties = PropertiesStorage<PropertiesKey>()
        tasksService = BackgroundTasksService.shared

        keys = KeysStorage()
        images = CacheImagesService()
        searchCards = SearchPlaceCardsCacheService(configs: configs,
                                                    properties: properties)
        likes = LikesService()
        places = PlacesCacheservice(configs: configs,
                                    properties: properties)

        positions = PositionsService()
        backgroundPositions = BackgroundPositionsServices(tasksService: tasksService)
        checkIns = CheckInService(positions: positions,
                                  backgroundPositions: backgroundPositions,
                                  searchCards: searchCards,
                                  configs: configs,
                                  keys: keys)
    }


    public struct ApiServices {

        public struct Users {

            public static var main: UsersMainApiService {
                return UsersMainApiService(configs: shared.configs, keys: shared.keys)
            }
            public static var auth: UsersAuthApiService {
                return UsersAuthApiService(shared.configs)
            }
        }

        public struct Places {

            public static var main: PlacesMainApiService {
                return PlacesMainApiService(shared.configs)
            }
            public static var clients: PlacesClientsApiService {
                return PlacesClientsApiService(shared.configs)
            }
        }
    }
}
