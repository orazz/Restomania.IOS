//
//  CacheRangeAdapter.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 23.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import IOSLibrary

internal class CacheRangeAdapter<TElement>  where TElement: ICached {

    private let _tag: String
    private let _filename: String
    private let _fileClient: FileSystem
    public let _queue: DispatchQueue
    private var _data: [TElement]

    public init(tag: String, filename: String) {

        _tag = tag
        _filename = filename
        _fileClient = FileSystem()
        _queue = DispatchQueue(label: "\(tag)-\(Guid.New)")

        _data = [TElement]()

        _queue.sync {
            self._data = self.load()
        }
    }

    //Local
    public var hasData: Bool {
        return 0 != _data.count
    }
    public var localData: [TElement] {
        return _data.map({ TElement.init(source: $0) })
    }
    public func rangeLocal(_ ids: [Long]) -> [TElement] {
        return _data.where({ ids.contains($0.ID) })
    }
    public func findInLocal(_ id: Long) -> TElement? {
        return _data.find({ $0.ID == id })
    }
    public func remove(_ id: Long) {

        _queue.sync {

            for (index, element) in _data.enumerated() {
                if (element.ID == id) {
                    _data.remove(at: index)
                }
            }
        }
        save()
    }
    public func unite(with range: [TElement]) {

        _queue.sync {

            for update in range {

                var found = false
                for (index, old) in _data.enumerated() {

                    if (update.ID == old.ID) {
                        self._data[index] = update
                        found = true
                        break
                    }
                }

                if (!found) {
                    self._data.append(update)
                }
            }
        }
        save()
    }

    public func save() {

        _queue.sync {

            do {
                let data = try JSONSerialization.data(withJSONObject: _data.map({ $0.toJSON() }), options: [])
                _fileClient.saveTo(_filename, data: data, toCache: false)

                Log.Debug(_tag, "Save data to storage.")
            } catch {
                Log.Warning(_tag, "Problem with save data.")
            }
        }
    }
    private func load() -> [TElement] {

        do {
            if (!_fileClient.isExist(_filename, inCache: false)) {
                return [TElement]()
            }

            let fileContent = _fileClient.load(_filename, fromCache: false)!
            let data = fileContent.data(using: .utf8)

            let range = try JSONSerialization.jsonObject(with: data!, options: []) as! [JSON]

            return range.map({ TElement.init(json: $0)! })
        } catch {
            Log.Warning(_tag, "Problem with load data.")

            return [TElement]()
        }
    }
}
