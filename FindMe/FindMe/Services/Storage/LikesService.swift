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

    private let _tag: String
    private let _queue: DispatchQueue
    private let _fileClient: FSOneFileClient
    private let _eventsAdapter: EventsAdapter<THandler>
    private var _data: [LikeContainer] = []

    //MARK: Initialization
    public override init() {

        _tag = String.tag(LikesService.self)
        _queue = DispatchQueue(label: "\(_tag)-\(Guid.new)")
        _fileClient = FSOneFileClient(filename: "favourites-places.json", inCache: false, tag: _tag)
        _eventsAdapter = EventsAdapter<THandler>(name: _tag)

        super.init()

        _data = loadCached()
    }
    private func loadCached() -> [LikeContainer] {

        do {
            if let content = _fileClient.load(),
                let data = content.data(using: .utf8) {

                return try JSONSerialization.parseRange(data: data)
            }
        }
        catch {

            if (_fileClient.isExist) {
                _fileClient.remove()
                Log.Warning(_tag, "Problem with load data. Remove storage file. Error: \(error)")
            }
        }

        return [LikeContainer]()
    }

    //MARK: Methods
    public func all() -> [Long] {
        return _data.map({ $0.placeId })
    }
    public func isLiked(place: Long) -> Bool {
        return nil != find(by: place)
    }
    public func like(place: Long) {

        Log.Debug(_tag, "Like place #\(place).")

        if nil == find(by: place) {

            _data.append(LikeContainer(placeId: place))
            save()
        }

        _eventsAdapter.Trigger(action: { handler in
            handler.like?(placeId: place)
            handler.change?(placeId: place, isLiked: true)
        })
    }
    public func unlike(place: Long) {

        Log.Debug(_tag, "Unlike place #\(place).")

        if let _ = find(by: place) {
            
            _data.remove(at: _data.index(where: { $0.placeId == place })!)
            save()
        }

        _eventsAdapter.Trigger(action: { handler in
            handler.unlike?(placeId: place)
            handler.change?(placeId: place, isLiked: false)
        })
    }
    private func find(by placeId: Long) -> LikeContainer? {
        return _data.find({ $0.placeId == placeId })
    }


    private func save() {

        do {

            let data = try JSONSerialization.serialize(data: self._data)
            self._fileClient.save(data: String(data: data, encoding: .utf8)!)
        }
        catch {

            Log.Warning(self._tag, "Problem with saving likes to file.")
        }
    }


    private class LikeContainer: Glossy {

        private struct Keys {

            public static let placeId = "PlaceID"
        }

        public let placeId: Long

        public init(placeId: Long){

            self.placeId = placeId
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
}

//MARK: IEventsEmitter
extension LikesService: IEventsEmitter {

    public func subscribe(guid: String, handler: LikesServiceDelegate, tag: String) {
        _eventsAdapter.subscribe(guid: guid, handler: handler, tag: tag)
    }
    public func unsubscribe(guid: String) {
        _eventsAdapter.unsubscribe(guid: guid)
    }
}
