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

    //MARK: Storage services
    public let keys: IKeysStorage
//    public let likes: LikesService
    public let positions: PositionsService
    public let checkIns: CheckInService
//
    //MARk: Cache services
    public let images: CacheImagesService
//    public let searchCards: SearchPlaceCardsCacheService


    private init() {

        configs = ConfigsStorage(plistName: "Configs")
        properties = PropertiesStorage<PropertiesKey>()
        backgrounds = BackgroundTaskManager.shared

        keys = KeysStorage()
//        likes = LikesService()
        positions = PositionsService(background: backgrounds)
        checkIns = CheckInService(positions: positions)
//
        images = CacheImagesService()
//        searchCards = SearchPlaceCardsCacheService(properties: properties)
    }
}
