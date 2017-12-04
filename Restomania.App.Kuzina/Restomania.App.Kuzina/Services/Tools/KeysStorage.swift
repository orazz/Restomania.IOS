//
//  KeysStorage.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import IOSLibrary

public class KeysStorage {

    private var tag = String.tag(KeysStorage.self)
    private var _data: [KeysContainer]
    private let _filename: String = "keys-storage.json"
    private let _client: FileSystem

    public init() {
        _data = [KeysContainer]()

        _client = FileSystem()

        if (_client.isExist(_filename, inCache: false)) {

            do {
                let fileContent = _client.load(_filename, fromCache: false)!
                let data = try JSONSerialization.jsonObject(with: fileContent.data(using: .utf8)!, options: []) as! [JSON]
                _data = [KeysContainer]()

                for json in data {
                    _data.append(KeysContainer(json: json))
                }
            } catch {
                _data = [KeysContainer]()
                _client.saveTo(_filename, data: "[]", toCache: false)
                Log.Debug(tag, "Problem with parse \(_filename) on load.")
            }
        } else {

            _data = [KeysContainer]()
        }

        Log.Info(tag, "Complete load service.")
    }

    private func save() {
        do {
            let builded = _data.map({ $0.toJSON()})
            let data = try JSONSerialization.data(withJSONObject: builded, options: [])

            _client.saveTo(_filename, data: data, toCache: false)
        } catch {
            Log.Error(tag, "Problem with save keys to storage")
        }

        Log.Debug(tag, "Save keys to storage.")
    }

    private class KeysContainer: Glossy {

        public var keys: ApiKeys
        public var rights: ApiRole

        public init() {
            self.keys = ApiKeys()
            self.rights = .user
        }
        public required init(json: JSON) {
            self.keys = ("keys" <~~ json)!
            self.rights = ("rights" <~~ json)!
        }

        public func toJSON() -> JSON? {
            return jsonify([
                "keys" ~~> self.keys,
                "rights" ~~> self.rights
                ])
        }
    }
}
extension KeysStorage {
    public func set(keys: ApiKeys, for rights: ApiRole) {

        for container in _data {
            if (rights == container.rights) {
                container.keys = keys
                save()
                return
            }
        }

        let container = KeysContainer()
        container.keys = keys
        container.rights = rights

        _data.append(container)
        save()
    }
    public func remove(for rights: ApiRole) {
        for (index, container) in _data.enumerated() {
            if (rights == container.rights) {
                _data.remove(at: index)
                break
            }
        }

        save()
    }
}
extension KeysStorage {
    public func isAuth(for rights: ApiRole) -> Bool {
        return nil != keys(for: rights)
    }
    public func keys(for rights: ApiRole) -> ApiKeys? {

        for container in _data {
            if (rights == container.rights) {
                return container.keys
            }
        }

        return nil
    }
    public func logout(for rights: ApiRole) {

        remove(for: rights)
    }
}
