//
//  CacheImagesService.swift
//  IOS Library
//
//  Created by Алексей on 18.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import AsyncTask
import Gloss

public class CacheImagesService {

    public struct DownloadResult {

        public let success: Bool
        public let data: Data?

        public init(data: Data? = nil) {
            self.success = nil != data
            self.data = data
        }
    }


    private let tag = String.tag(CacheImagesService.self)
    private let adapter: CacheAdapter<CacheImageContainer>
    private let clearQueue: DispatchQueue
    private let fileSystem: FileSystem
    private var lastID: Long
    private let directoryName = "images-cache"
    private let cacheTime = Double(7 * 24 * 60 * 60)

    public init() {

        adapter = CacheAdapter<CacheImageContainer>(tag: tag, filename: "image-cache.json")
        clearQueue = DispatchQueue(label: "\(tag)-clear-queue")
        fileSystem = FileSystem()
        lastID = adapter.extender.all.max(by: {(left, right) in left.ID > right.ID })?.ID ?? 0

        Log.Info(tag, "Complete load service.")
    }
    public func load() {
        adapter.loadCached()
        launchService()
    }

    public func download(url: String) -> Task<DownloadResult> {

        return Task { (handler:@escaping (_:DownloadResult) -> Void) in

            //Take from cache
            if let image = self.adapter.extender.find({ $0.url == url }) {
                if let content = self.fileSystem.loadData(image.filename, fromCache: true) {

                    handler(DownloadResult(data: content))

                    image.lastUseDate = Date()
                    self.adapter.addOrUpdate(image)

                    Log.Debug(self.tag, "Take image from cache: \(url)")
                    return
                }
                else {
                    self.adapter.remove(image)
                }
            }

            //Load
            let session = URLSession.shared
            let request = session.dataTask(with: URL(string: url)!, completionHandler: {(data, _, error) in

                guard let data = data, error == nil else {
                    handler(DownloadResult(data:nil))
                    Log.Warning(self.tag, "Problem with download image from url: \(url).")

                    return
                }

                let container = CacheImageContainer()
                container.ID = self.lastID
                container.url = url
                container.filename = "\(self.directoryName)/\(Guid.new).image"
                self.lastID += 1

                self.fileSystem.saveTo(container.filename, data: data, toCache: true)
                self.adapter.addOrUpdate(container)

                handler(DownloadResult(data: data))
                Log.Debug(self.tag, "Download and cache image for url: \(url)")
            })
            request.resume()
        }
    }

    private func launchService() {

        if (!fileSystem.isExist(directoryName, inCache: true)) {
            fileSystem.createDirectory(directoryName, inCache: true)
        }

        checkCachedImages()
        removeOldImages()
    }
    private func checkCachedImages() {

        var needRemove = [Long]()
        for image in adapter.extender.all {
            if (!fileSystem.isExist(image.filename, inCache: true)) {
                needRemove.append(image.ID)
            }
        }
        adapter.remove(needRemove)

        Log.Debug(tag, "Check cached images.")
    }
    private func removeOldImages() {

        clearQueue.async {

            let date = Date()
            let old = self.adapter.extender.where({ self.cacheTime < abs($0.lastUseDate.timeIntervalSince(date)) })
            self.adapter.remove(old)

            for image in old {
                self.fileSystem.remove(image.filename, fromCache: true)
            }

            Log.Debug(self.tag, "Remove old cached images.")
        }
    }

    
    private class CacheImageContainer: ICached {
        
        public var ID: Long
        public var url: String
        public var filename: String
        public var lastUseDate: Date
        
        public init() {
            
            self.ID = 0
            self.url = String.empty
            self.filename = String.empty
            self.lastUseDate = Date()
        }
        public required init(source: CacheImageContainer) {
            
            self.ID = source.ID
            self.url = source.url
            self.filename = source.filename
            self.lastUseDate = source.lastUseDate
        }
        public required init(json: JSON) {
            
            self.ID = ("id" <~~ json)!
            self.url = ("url" <~~ json)!
            self.filename = ("filename" <~~ json)!
            self.lastUseDate = Date.parseJson(value: ("lastUseDate" <~~ json)!)
        }
        public func toJSON() -> JSON? {
            
            return jsonify([
                "id" ~~> self.ID,
                "url" ~~> self.url,
                "filename" ~~> self.filename,
                "lastUseDate" ~~> self.lastUseDate.prepareForJson()
                ])
        }
    }
}











