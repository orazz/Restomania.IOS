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
import AsyncTask

public class CheckInService: NSObject, PositionServiceDelegate {

    private let _checkinTolerance = 200.0
    private let _foregroundDelay = 10.0
    private let _backgroundDelay = 60.0

    private let _tag = String.tag(CheckInService.self)
    private let _guid = Guid.new
    private var _checkInTimer: Timer? = nil

    private let _positionsService: PositionsService
    private let _backgroundPositions: BackgroundPositionsServices
    private let searchCardsCache: SearchPlaceCardsCacheService
    private let _apiService: UsersMainApiService

    public init(positions: PositionsService,
                backgroundPositions: BackgroundPositionsServices,
                searchCards: SearchPlaceCardsCacheService,
                configs: ConfigsStorage,
                keys: IKeysStorage) {

        self._positionsService = positions
        self._backgroundPositions = backgroundPositions
        self.searchCardsCache = searchCards
        self._apiService = ApiServices.Users.main

        super.init()

        subscribe()
        enterToForeground()
    }
    private func subscribe() {

        _positionsService.subscribe(guid: _guid, handler: self, tag: _tag)
        _backgroundPositions.subscribe(guid: _guid, handler: self, tag: _tag)

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
    @objc public func tryCheckIn() {

        Log.Debug(_tag, "Try check in.")

        var lastPosition: PositionsService.Position? = nil

        if (_backgroundPositions.isInForeground) {
            lastPosition = _positionsService.lastPosition
        }
        else if (_backgroundPositions.isInBackground) {
            lastPosition = _backgroundPositions.lastPosition
        }

        if let position = lastPosition {

            Task<Any?>(action: { done in

//                self.messageToSlack(position)
                self.checkPlaces(on: position)

                Log.Info(self._tag, "Process new location.")

                done(nil)
            }).async(.background, completion: { _ in })
        }
    }
    private func checkPlaces(on currentLocation: PositionsService.Position) {

        var places = [(place: SearchPlaceCard, distance: Double)]()
        for place in searchCardsCache.cache.all {
            if isIn(place: place, by: currentLocation) {

                let placeLocation = PositionsService.Position(lat: place.location.latitude, lng: place.location.longitude).toLocation()
                let distance = currentLocation.toLocation().distance(from: placeLocation)

                places.append((place: place, distance: distance))
            }
        }

        if (places.isEmpty) {
            return
        }
        else if (0 == places.count) {
            checkIn(placeId: places.first!.place.ID)
        }
        else {

            let min = places.min(by: { $0.distance < $1.distance })
            checkIn(placeId: min!.place.ID)
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
                
                Log.warning(self._tag, "Problem with checkin in #\(placeId).")
            }
        })
    }
    private func messageToSlack(_ position: PositionsService.Position) {
        SlackNotifier.notify("<\(_tag)>: \n`\(Date())` \nlat: \(position.latitude) \nlng: \(position.longtitude) \n*+-\(position.accuracy)m*")
    }

    //MARK: PositionServiceDelegate
    public func updateLocation(positions: [PositionsService.Position]) {

        if (_backgroundPositions.isInForeground) {
            tryCheckIn()
        }
    }

    //MARK: Events
    @objc private func enterToBackground() {
        relaunchTimer()
    }
    @objc private func enterToForeground() {
        relaunchTimer()
    }
    private func relaunchTimer() {

        _checkInTimer?.invalidate()
        _checkInTimer = nil

        var time = 0.0
        if (_backgroundPositions.isInForeground) {
            time = _foregroundDelay
        }
        else if (_backgroundPositions.isInBackground) {
            time = _backgroundDelay
        }
        else {
            return
        }

        _checkInTimer = Timer.scheduledTimer(timeInterval: time,
                                             target: self,
                                             selector: #selector(tryCheckIn),
                                             userInfo: nil,
                                             repeats: true)
    }
}
