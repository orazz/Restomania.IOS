//
//  CacheServices.swift
//  FindMe
//
//  Created by Алексей on 28.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class CacheServices {

    private static var _searchCards: SearchPlaceCardsCacheService?
    private static var _places: PlacesCacheService?
    private static var _images: CacheImagesService?

    public static var searchCards: SearchPlaceCardsCacheService {
        let service = _searchCards ?? SearchPlaceCardsCacheService(configs: configs, properties: properties)
        _searchCards = service

        return service
    }
    public static var places: PlacesCacheService {
        let service = _places ?? PlacesCacheService(configs: configs, properties: properties)
        _places = service

        return service
    }
    public static var images: CacheImagesService {
        let service = _images ?? CacheImagesService()
        _images = service

        return service
    }

    public static func load() {

        searchCards.load()
        places.load()
        images.load()
    }

    private static var configs: ConfigsStorage {
        return ToolsServices.shared.configs
    }
    private static var properties: PropertiesStorage<PropertiesKey> {
        return ToolsServices.shared.properties
    }
}
