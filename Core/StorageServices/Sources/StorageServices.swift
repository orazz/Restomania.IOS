//
//  CacheServices.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 16.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import Swinject
import CoreTools
import CoreApiServices

open class StorageServices {

    open static func register(in container: Container) {

        //Cache
        container.register(PlacesCacheService.self, factory: { r in
            PlacesCacheService(r.resolve(PlaceSummariesApiService.self)!) }).inObjectScope(.container)

        container.register(MenuCacheService.self, factory: { r in
            MenuCacheService(r.resolve(MenuSummariesApiService.self)!) }).inObjectScope(.container)

        container.register(CardsCacheService.self, factory: { r in
            CardsCacheService(r.resolve(UserCardsApiService.self)!,
                              r.resolve(ApiKeyService.self)!) }).inObjectScope(.container)

        container.register(OrdersCacheService.self, factory: { r in
            OrdersCacheService(r.resolve(UserOrdersApiService.self)!,
                               r.resolve(ApiKeyService.self)!) }).inObjectScope(.container)

        container.register(CacheImagesService.self, factory: { r in CacheImagesService() }).inObjectScope(.container)



        //Cart
        container.register(PlaceCartsFactory.self, factory: { _ in PlaceCartsFactory() }).inObjectScope(.container)

        //Keys
        container.register(ApiKeyService.self, factory: { r in
            KeysStorage(r.resolve(ConfigsContainer.self)!,
                        r.resolve(LightStorage.self)!) }).inObjectScope(.container)
    }

    open static func load(from container: Container) {

        container.resolve(PlacesCacheService.self)!.load()
        container.resolve(MenuCacheService.self)!.load()
        container.resolve(CardsCacheService.self)!.load()
        container.resolve(OrdersCacheService.self)!.load()
        container.resolve(CacheImagesService.self)!.load()
    }
}
