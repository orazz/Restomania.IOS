//
//  FavouritesService.swift
//  FindMe
//
//  Created by Алексей on 27.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

@objc public protocol LikesServiceDelegate{

    @objc optional func like(placeId: Long)
    @objc optional func unlike(placeId: Long)
    @objc optional func change(placeId: Long, isLiked: Bool)
}
public class LikesService: NSObject {
    public typealias THandler = LikesServiceDelegate

    private let _tag = String.tag(LikesService.self)
    private let client = ApiServices.Users.pleasantPlaces
    private let adapter: CacheAdapter<LikeContainer>
    private let eventsAdapter: EventsAdapter<THandler>
    private var extender: CacheAdapterExtender<LikeContainer> {
        return adapter.extender
    }

    //MARK: Initialization
    public override init() {

        adapter =  CacheAdapter<LikeContainer>(tag: _tag, filename: "favourites-places.json")
        eventsAdapter = EventsAdapter<THandler>(tag: _tag)

        super.init()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enterToBackground),
                                               name: Notification.Name.UIApplicationDidEnterBackground,
                                               object: nil)
    }
    public func clear() {
        adapter.clear()
    }
    public func load() {
        adapter.loadCached()
    }


    //MARK: Methods
    public func all() -> [Long] {
        return extender.all.map({ $0.placeId })
    }
    public func filterLiked(_ range: [SearchPlaceCard]) -> [SearchPlaceCard] {

        let liked = all()

        return range.filter({ liked.contains($0.ID) })
    }
    public func isLiked(_ placeId: Long) -> Bool {
        return nil != extender.find(placeId)
    }
    public func like(_ placeId: Long) {

        Log.Debug(_tag, "Like place #\(placeId).")

        adapter.addOrUpdate(LikeContainer(for: placeId))

        eventsAdapter.Trigger(action: { handler in
            handler.like?(placeId: placeId)
            handler.change?(placeId: placeId, isLiked: true)
        })
    }
    public func unlike(_ placeId: Long) {

        Log.Debug(_tag, "Unlike place #\(placeId).")

        adapter.remove(placeId)

        eventsAdapter.Trigger(action: { handler in
            handler.unlike?(placeId: placeId)
            handler.change?(placeId: placeId, isLiked: false)
        })
    }

    @objc private func enterToBackground() {
        saveToRemote()
    }

    //MARK: Send'n'Update
    public func saveToRemote() {

        let request = client.update(places: self.all())
        request.async(.background, completion: { response in

            if response.isFail {
                if (response.statusCode != .Forbidden && response.statusCode != .ConnectionError) {
                    Log.Warning(self._tag, "Problem with update pleasant places.")
                }
            }
            else if response.isSuccess {
                Log.Info(self._tag, "Update plesant places.")
            }
        })
    }
    public func takeFromRemote() {

        let request = client.take()
        request.async(.background, completion: { response in

            if response.isFail {
                if (response.statusCode != .Forbidden && response.statusCode != .ConnectionError) {
                    Log.Warning(self._tag, "Problem with take pleasant places.")
                }
            }
            else if response.isSuccess {
                Log.Info(self._tag, "Request pleasant places.")

                let likes = response.data!
                for placeId in likes {
                    self.like(placeId)
                }
            }
        })
    }
}

//MARK: IEventsEmitter
extension LikesService: IEventsEmitter {

    public func subscribe(guid: String, handler: LikesServiceDelegate, tag: String) {
        eventsAdapter.subscribe(guid: guid, handler: handler, tag: tag)
    }
    public func unsubscribe(guid: String) {
        eventsAdapter.unsubscribe(guid: guid)
    }
}

private class LikeContainer: ICached {

    private struct Keys {

        public static let placeId = "PlaceID"
    }

    public var ID: Long {
        return placeId
    }
    public let placeId: Long

    public init(for placeId: Long){

        self.placeId = placeId
    }

    //MARK: ICopying
    public required init(source: LikeContainer) {

        self.placeId = source.placeId
    }

    //MARK: Glossy
    public required init(json: JSON) {

        self.placeId = (Keys.placeId <~~ json)!
    }
    public func toJSON() -> JSON? {

        return jsonify([

            Keys.placeId ~~> self.placeId
            ])
    }
}
