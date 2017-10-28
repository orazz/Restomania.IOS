//
//  CheckInService.swift
//  FindMe
//
//  Created by Алексей on 04.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import Foundation
import IOSLibrary

public class CheckInService: NSObject, PositionServiceDelegate {

    private let _checkinTolerance = 500.0

    private let _tag = String.tag(CheckInService.self)
    private let _guid = Guid.new
    private var _backgroundTask = UIBackgroundTaskInvalid
    private let _application = UIApplication.shared

    private let _positionsService: PositionsService
    private let _searchCardsService: SearchPlaceCardsCacheService
    private let _tasksService: BackgroundTasksService
    private let _apiService: UsersMainApiService

    public init(positions: PositionsService,
                searchCards: SearchPlaceCardsCacheService,
                tasksService: BackgroundTasksService,
                configs: ConfigsStorage,
                keys: IKeysStorage) {

        self._positionsService = positions
        self._searchCardsService = searchCards
        self._tasksService = tasksService
        self._apiService = UsersMainApiService(configs: configs, keys: keys)

        super.init()

        self._positionsService.subscribe(guid: _guid, handler: self, tag: _tag)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enterToBackground),
                                               name: Notification.Name.UIApplicationDidEnterBackground,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enterToForeground),
                                               name: Notification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
    }


    //MARK: Methods
    public func launch() {

        _positionsService.requestPermission()
        _positionsService.startTracking()
    }
    public func tryCheckIn() {

        guard let coordinates = _positionsService.lastPosition else {
            return
        }

        for place in _searchCardsService.allLocal {
            if isIn(place: place, by: coordinates) {

                checkIn(placeId: place.ID)
                break
            }
        }
    }
    private func isIn(place: SearchPlaceCard, by coordinates: PositionsService.Position) -> Bool {

        let location = place.location

        return coordinates.isCorrelateWith(lat: location.latitude, long: location.longitude, tolerance: _checkinTolerance)
    }
    public func checkIn(placeId: Long) {

        let response = _apiService.checkIn(placeId: placeId)
        response.async(.background, completion: { response in

            if (response.isFail) {
                
                Log.Warning(self._tag, "Problem woth checkin in #\(placeId).")
            }
        })
    }


    //MARK: PositionServiceDelegate
    public func updateLocation(positions: [PositionsService.Position]) {

        if (_application.applicationState == .background) {
            _backgroundTask = _tasksService.beginNew()
        }

        tryCheckIn()
    }


    //MARK: Events
    @objc private func enterToBackground() {

        let service = self._positionsService
        service.requestPermission(always: true)

        if (service.canUseInBackground) {
            service.startTracking()
        }

        _backgroundTask = _tasksService.beginNew()
    }
    @objc private func enterToForeground() {

        let service = self._positionsService

        if (service.canUseInBackground) {
            service.stopTracking()
        }

        _tasksService.end(task: _backgroundTask)
    }
}
