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

public protocol IKeysCRUDStorage: IKeysStorage {

    func set(keys: AccessKeys, for rights: AccessRights)
    func remove(for rights: AccessRights)
}
public class KeysStorage: IKeysCRUDStorage, ILoggable {

    public var tag: String {
        return "KeysStorage"
    }

    private var _data: [KeysContainer]
    private let _filename: String = "keys_storage.json"
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
    public func set(keys: AccessKeys, for rights: AccessRights) {

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
    public func remove(for rights: AccessRights) {
        for (index, container) in _data.enumerated() {
            if (rights == container.rights) {
                _data.remove(at: index)
                break
            }
        }

        save()
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

    public func keysFor(rights: AccessRights) -> AccessKeys? {

        for container in _data {
            if (rights == container.rights) {
                return container.keys
            }
        }

        return nil
    }
}
private class KeysContainer: Glossy {

    public var keys: AccessKeys
    public var rights: AccessRights

    public init() {
        self.keys = AccessKeys()
        self.rights = .User
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
