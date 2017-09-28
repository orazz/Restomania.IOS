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

public class LikesService {

    private let _tag: String
    private let _queue: DispatchQueue
    private let _fileClient: FSOneFileClient
    private let _data: [LikeContainer]

    //MARK: Initialization
    public init() {

        _tag = String.tag(LikesService.self)
        _queue = DispatchQueue(label: "\(_tag)-\(Guid.new)")
        _fileClient = FSOneFileClient(filename: "favourites-places.json", inCache: false, tag: _tag)
        _data = loadCached()
    }
    private func loadCached() -> [LikeContainer] {

        do {
            if let data = _fileClient.loadData() {

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
