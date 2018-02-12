//
//  CacheServices.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 16.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class CacheServices {

    private static var _places: PlacesCacheService?
    private static var _menu: MenuCacheService?
    private static var _orders: OrdersCacheService?
    private static var _cards: CardsCacheService?
    private static var _images: CacheImagesService?

    public static var places: PlacesCacheService {
        if ( nil == _places) {
            _places = PlacesCacheService()
        }

        return _places!
    }
    public static var menus: MenuCacheService {
        if (nil == _menu) {
            _menu = MenuCacheService()
        }

        return _menu!
    }
    public static var orders: OrdersCacheService {
        if (nil == _orders) {
            _orders = OrdersCacheService()
        }

        return _orders!
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
        menus.load()
        cards.load()
        orders.load()
        images.load()
    }
}