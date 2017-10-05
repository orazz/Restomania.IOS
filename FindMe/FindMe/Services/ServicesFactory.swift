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
    public let backgrounds: BackgroundTaskManager

    //MARk: Cache services
    public let keys: IKeysStorage
    public let images: CacheImagesService
    public let searchCards: SearchPlaceCardsCacheService
    public let likes: LikesService

    //MARK: Storage services
    public let positions: PositionsService
//    public let checkIns: CheckInService


    private init() {

        configs = ConfigsStorage(plistName: "Configs")
        properties = PropertiesStorage<PropertiesKey>()
        backgrounds = BackgroundTaskManager.shared

        keys = KeysStorage()
        images = CacheImagesService()
        searchCards = SearchPlaceCardsCacheService(configs: configs, properties: properties)
        likes = LikesService()

        positions = PositionsService(background: backgrounds)
//        checkIns = CheckInService(positions: positions, searchCards: searchCards)
//
    }
}
