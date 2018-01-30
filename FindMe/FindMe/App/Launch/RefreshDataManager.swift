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
import AsyncTask

public class RefreshDataManager {

    private static var _instance: RefreshDataManager?
    public static var shared: RefreshDataManager {

        if (nil == _instance) {

            _instance = RefreshDataManager();
        }

        return _instance!
    }


    private let _tag = String.tag(RefreshDataManager.self)
    private var apiQueue: AsyncQueue
    private let _application = UIApplication.shared

    private let _cards: SearchPlaceCardsCacheService
    private let _places: PlacesCacheService

    private init() {

        self.apiQueue = AsyncQueue.createForApi(for: _tag)

        self._cards = CacheServices.searchCards
        self._places = CacheServices.places
    }


    //#MARK: Methods
    public func launch() {

        registerHooks()
        refreshUserData()
    }


    public func refreshData(with completeHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        let completer = Completer.init(limit: 1, complete: { results in

            var success = false

            for (_, result) in results {
                success = success || result
            }

            if (success) {
                completeHandler(.newData)
            }
            else {
                completeHandler(.failed)
            }
        });

        let cards = _cards.refresh()
        cards.async(apiQueue, completion: completer.ender())
    }



    private func registerHooks() {

        _application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
    }
    private func refreshUserData() {

        refreshApiKeys()

        LogicServices.shared.likes.takeFromRemote()
        LogicServices.shared.towns.takeFromRemote()
    }
    private func refreshApiKeys() {

        let auth = ApiServices.Auth.main
        let keys = ToolsServices.shared.keys
        let request = auth.refresh(for: .user)
        request.async(apiQueue, completion: { response in

            if (response.isSuccess) {
                keys.set(for: .user, keys: response.data!)
                Log.Debug(self._tag, "Refresh api keys.")
            }
            else if (response.isFail) {

                if (response.statusCode == .Forbidden) {
                    keys.logout(.user)
                    Log.warning(self._tag, "Remove old api keys.")
                }
            }
        })
    }
}
private class Completer {

    private let limit: Int
    private var completeCount: Int
    private var results: [Int: Bool]
    private let complete: (([Int: Bool]) -> Void)

    public init(limit: Int, complete: @escaping (([Int: Bool]) -> Void)) {

        self.limit = limit
        self.completeCount = 0
        self.results = [:]
        self.complete = complete
    }

    public func ender() -> ((Bool) -> Void) {
        return { result in

            self.completeCount += 1
            self.results[self.completeCount] = result

            if (self.completeCount == self.limit) {
                self.complete(self.results)
            }
        }
    }
}
