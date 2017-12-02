//
//  ActionsCacheService.swift
//  FindMe
//
//  Created by Алексей on 29.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import AsyncTask

public class ActionsCacheService {

    private let tag = String.tag(ActionsCacheService.self)
    private let adapter: CacheAdapter<Action>
    private let client = ApiServices.Places.actions
    private let apiQueue: AsyncQueue

    public var cache: CacheAdapterExtender<Action> {
        return adapter.extender
    }

    public init() {

        adapter = CacheAdapter<Action>(tag: tag, filename: "places-actions.json")
        apiQueue = AsyncQueue.createForApi(for: tag)
    }
    public func load() {
        adapter.loadCached()
    }
    public func clear() {
        adapter.clear()
    }

    //MARK: Methods
    public func find(place: Long, with parameters: SelectParameters) -> Task<ApiResponse<[Action]>> {

        Log.Debug(tag, "Request actions for place #\(place)")

        return Task<ApiResponse<[Action]>>(action: { handler in

            let request = self.client.all(for: place, with: parameters)
            request.async(self.apiQueue, completion: { response in

                if let update = response.data {
                    self.adapter.addOrUpdate(update)
                    self.adapter.clearOldCached()
                }

                handler(response)
            })
        })
    }
    public func find(action: Long) -> Task<ApiResponse<Action>> {

        Log.Debug(tag, "Request action #\(action)")

        return Task<ApiResponse<Action>>(action: { handler in

            let request = self.client.find(action)
            request.async(self.apiQueue, completion: { response in

                if let update = response.data {
                    self.adapter.addOrUpdate(update)
                }

                handler(response)
            })
        })
    }
}
