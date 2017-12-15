//
//  CacheServices.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 16.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class CacheServices {

    private static var _places: PlacesCacheService?
    private static var _menu: MenuCacheService?
    private static var _cards: CardsCacheService?
    private static var _images: CacheImagesService?

    public static var places: PlacesCacheService {
        if ( nil == _places) {
            _places = PlacesCacheService()
        }

        return _places!
    }
    public static var menu: MenuCacheService {
        if (nil == _menu) {
            _menu = MenuCacheService()
        }

        return _menu!
    }
    public static var cards: CardsCacheService {
        if (nil == _cards) {
            _cards = CardsCacheService()
        }

        return _cards!
    }
    public static var images: CacheImagesService {
        if (nil == _images) {
            _images = CacheImagesService()
        }

        return _images!
    }

    public static func load() {

        places.load()
        menu.load()
        cards.load()
    }
}
