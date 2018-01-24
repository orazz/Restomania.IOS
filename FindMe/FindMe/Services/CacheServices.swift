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
    public static var searchCards: SearchPlaceCardsCacheService {
        let service = _searchCards ?? SearchPlaceCardsCacheService(properties: properties)
        _searchCards = service

        return service
    }

    private static var _places: PlacesCacheService?
    public static var places: PlacesCacheService {
        let service = _places ?? PlacesCacheService(properties: properties)
        _places = service

        return service
    }

    private static var _actions: ActionsCacheService?
    public static var actions: ActionsCacheService {
        let service = _actions ?? ActionsCacheService()
        _actions = service

        return service
    }

    private static var _images: CacheImagesService?
    public static var images: CacheImagesService {
        let service = _images ?? CacheImagesService()
        _images = service

        return service
    }

    private static var _chatMessages: ChatMessagesCacheService?
    public static var chatMessages: ChatMessagesCacheService {
        let service = _chatMessages ?? ChatMessagesCacheService()
        _chatMessages = service

        return service
    }

    private static var _chatDialogs: ChatDialogsCacheService?
    public static var chatDialogs: ChatDialogsCacheService {
        let service = _chatDialogs ?? ChatDialogsCacheService()
        _chatDialogs = service

        return service
    }


    public static func load() {

        searchCards.load()
        places.load()
        actions.load()

        images.load()

        chatMessages.load()
        chatDialogs.load()
    }

    private static var configs: ConfigsStorage {
        return ToolsServices.shared.configs
    }
    private static var properties: PropertiesStorage<PropertiesKey> {
        return ToolsServices.shared.properties
    }
}
