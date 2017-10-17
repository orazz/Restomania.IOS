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


    private let _tag = String.tag(CacheImagesService.self)
    private let _adapter: CacheRangeAdapter<CacheImageContainer>
    private let _queue: DispatchQueue
    private let _fileClient: FileSystem
    private let _directoryName = "images-cache"
    private var _lastID: Long
    private let _cacheTime = Double(7 * 24 * 60 * 60)

    public init() {

        _adapter = CacheRangeAdapter<CacheImageContainer>(tag: _tag, filename: "image-cache.json")
        _queue  = DispatchQueue(label: _tag)
        _fileClient = FileSystem()
        _lastID = _adapter.localData.max(by: {(left, right) in left.ID > right.ID })?.ID ?? 0

        Log.Info(_tag, "Complete load service.")

        checkDirectories()
    }

    public func download(url: String) -> Task<DownloadResult> {

        return Task { (handler:@escaping (_:DownloadResult) -> Void) in

            //Take from cache
            for image in self._adapter.localData {
                if (url == image.url) {

                    let content = self._fileClient.loadData(image.filename, fromCache: true)
                    if nil == content {

                        self._adapter.remove(image)
                        break
                    }

                    handler(DownloadResult(data: content!))
                    Log.Debug(self._tag, "Take image from cache: \(url)")

                    return
                }
            }

            //Load
            let session = URLSession.shared
            let request = session.dataTask(with: URL(string: url)!, completionHandler: {(data, _, error) in

                guard let data = data, error == nil else {
                    handler(DownloadResult(data:nil))
                    Log.Warning(self._tag, "Problem with download image from url: \(url).")

                    return
                }

                let container = CacheImageContainer()
                container.ID = self._lastID
                container.url = url
                container.filename = "\(self._directoryName)/\(Guid.new).image"
                self._lastID += 1

                self._fileClient.saveTo(container.filename, data: data, toCache: true)
                self._adapter.addOrUpdate(container)

                handler(DownloadResult(data: data))
                Log.Debug(self._tag, "Download aand cache image for url: \(url)")
            })
            request.resume()
        }
    }

    private func checkDirectories() {

        if (!_fileClient.isExist(_directoryName, inCache: true)) {

            _fileClient.createDirectory(_directoryName, inCache: true)
        }

        checkCachedImages()
        removeOldImages()
    }
    private func checkCachedImages() {

        for image in _adapter.localData {
            if (!_fileClient.isExist(image.filename, inCache: true)) {

                _adapter.remove(image.ID)
            }
        }

        Log.Debug(_tag, "Check cached images.")
    }
    private func removeOldImages() {

        _queue.async {

            let date = Date()

            let images = self._adapter.localData
            let old = images.where({ self._cacheTime < abs($0.lastUseDate.timeIntervalSince(date)) })
            self._adapter.remove(old)

            for image in old {
                self._fileClient.remove(image.filename, fromCache: true)
            }

            Log.Debug(self._tag, "Remove old cached images.")
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











