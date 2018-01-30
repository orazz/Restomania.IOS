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

public protocol KeysStorageDelegate {
    func set(keys: ApiKeys, for role: ApiRole)
    func remove(for role: ApiRole)
}
public class KeysStorage {

    private var tag = String.tag(KeysStorage.self)
    private var allKeys: [KeysContainer]
    private let file: FSOneFileClient
    private let eventsAdapter: EventsAdapter<KeysStorageDelegate>

    public init() {
        allKeys = [KeysContainer]()

        file = FSOneFileClient(filename: "keys-storage.json", inCache: false, tag: tag)
        eventsAdapter = EventsAdapter<KeysStorageDelegate>(tag: tag)

        load()

        Log.Info(tag, "Service is load.")
    }

    private func load() {

        if (!file.isExist) {
            return
        }

        do {
            let fileContent = file.loadData()
            allKeys = try JSONSerialization.parseRange(data: fileContent!)
        } catch {}
    }
    private func save() {
        do {
            let data = try JSONSerialization.serialize(data: allKeys)

            file.save(data: data)
        } catch {
            Log.error(tag, "Problem with save keys to file")
        }

        Log.Debug(tag, "Save auth keys.")
    }

    private class KeysContainer: Glossy {

        public var keys: ApiKeys
        public var role: ApiRole

        public init(keys: ApiKeys, role: ApiRole) {
            self.keys = keys
            self.role = .user
        }
        public required init(json: JSON) {
            self.keys = ("keys" <~~ json)!
            self.role = ("rights" <~~ json)!
        }

        public func toJSON() -> JSON? {
            return jsonify([
                "keys" ~~> self.keys,
                "rights" ~~> self.role
                ])
        }
    }
}
extension KeysStorage {
    public func set(keys: ApiKeys, for role: ApiRole) {

        if let container = allKeys.find({ $0.role == role }) {
            container.keys = keys
        } else {
            let container = KeysContainer(keys: keys, role: role)
            allKeys.append(container)
        }

        save()
        eventsAdapter.invoke({ $0.set(keys: keys, for: role) })
    }
    public func remove(for role: ApiRole) {

        if let index = allKeys.index(where: { $0.role == role }) {
            allKeys.remove(at: index)
        }

        save()
        eventsAdapter.invoke({ $0.remove(for: role) })
    }

    public func isAuth(for rights: ApiRole) -> Bool {
        return nil != keys(for: rights)
    }
    public func keys(for rights: ApiRole) -> ApiKeys? {
        return allKeys.find({ $0.role == rights})?.keys
    }
    public func logout(for rights: ApiRole) {
        remove(for: rights)
    }
}
extension KeysStorage: IEventsEmitter {
    public typealias THandler = KeysStorageDelegate

    public func subscribe(guid: String, handler: KeysStorageDelegate, tag: String) {
        eventsAdapter.subscribe(guid: guid, handler: handler, tag: tag)
    }
    public func unsubscribe(guid: String) {
        eventsAdapter.unsubscribe(guid: guid)
    }
}
