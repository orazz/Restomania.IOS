//
//  CacheImagesService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 23.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import AsyncTask
import Gloss
import IOSLibrary

public class CacheImagesService {

    public let tag = "CacheImagesService"
    private let _adapter: CacheRangeAdapter<CacheImageContainer>
    private let _fileClient: FileSystem
    private let _lastID: Long

    public init() {

        _adapter = CacheRangeAdapter<CacheImageContainer>(tag: tag, filename: "image-cache.json")
        _fileClient = FileSystem()
        _lastID = 0

        Log.Info(tag, "Complete load service.")
    }
}
private class CacheImageContainer: ICached {

    public var ID: Long
    public var url: String
    public var path: String
    public var lastUseDate: Date

    public init() {

        self.ID = 0
        self.url = String.Empty
        self.path = String.Empty
        self.lastUseDate = Date()
    }
    public required init(source: CacheImageContainer) {

        self.ID = source.ID
        self.url = source.url
        self.path = source.path
        self.lastUseDate = source.lastUseDate
    }
    public required init(json: JSON) {

        self.ID = ("id" <~~ json)!
        self.url = ("url" <~~ json)!
        self.path = ("path" <~~ json)!
        self.lastUseDate = ("lastUseDate" <~~ json)!
    }

    public func toJSON() -> JSON? {

        return jsonify([
                "id" ~~> self.ID,
                "url" ~~> self.url,
                "path" ~~> self.path,
                "lastUseDate" ~~> self.lastUseDate
            ])
    }
}
