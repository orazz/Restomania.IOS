//
//  RefreshDataManager.swift
//  FindMe
//
//  Created by Алексей on 25.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class RefreshDataManager {

    private static var _instance: RefreshDataManager?
    public static var shared: RefreshDataManager {

        if (nil == _instance) {

            _instance = RefreshDataManager();
        }

        return _instance!
    }


    private let _tag = String.tag(RefreshDataManager.self)
    private let _application = UIApplication.shared

    private let _cards: SearchPlaceCardsCacheService
    private let _places: PlacesCacheservice

    private init() {

        self._cards = CacheServices.searchCards
        self._places = CacheServices.places
    }


    //#MARK: Methods
    public func register() {

        _application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
    }
    public func refreshData() {

        _cards.refresh()
//        _places.refresh()

//        SlackNotifier.notify("<\(_tag)>: Refresh data.")
    }
}
