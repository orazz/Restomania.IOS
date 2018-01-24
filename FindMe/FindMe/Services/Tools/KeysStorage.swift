//
//  KeysStorage.swift
//  FindMe
//
//  Created by Алексей on 24.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss


public protocol KeysStorageDelegate {
    func set(keys: ApiKeys, for role: ApiRole)
    func remove(for role: ApiRole)
}
public class KeysStorage {

    private let tag = String.tag(KeysStorage.self)
    private let eventsAdapter: EventsAdapter<KeysStorageDelegate>
    private let fileAdapter: FSOneFileClient
    private var data: [KeysContainer] = []

    public init() {

        eventsAdapter = EventsAdapter(tag: tag)
        fileAdapter = FSOneFileClient(filename: "keys.json", inCache: false, tag: tag)
        data = load()

        Log.Info(tag, "Load service.")
    }
    private func load() -> [KeysContainer] {

        if fileAdapter.isExist,
           let content = fileAdapter.loadData() {

            do {
                return try JSONSerialization.parseRange(data: content)
            }
            catch {
                fileAdapter.save(data: "[]")
            }
        }

        return []
    }
    private func save() {

        do {
            let data = try JSONSerialization.serialize(data: self.data)
            fileAdapter.save(data: data)
        }
        catch {

            Log.Error(tag, "Problem with save keys to file.")
        }
    }
    
    
    public func isAuth(rights: ApiRole) -> Bool {
        return nil != keys(for: rights)
    }
    public func keys(for rights: ApiRole) -> ApiKeys? {

        return data.find({ rights == $0.rights })?.keys
    }
    public func set(for role: ApiRole, keys: ApiKeys) {

        logout(role)
        data.append(KeysContainer(keys: keys, rights: role))

        save()
        eventsAdapter.invoke({ $0.set(keys: keys, for: role) })
    }
    public func logout(_ role: ApiRole) {

        if let index = data.index(where: { role == $0.rights }) {
            data.remove(at: index)
        }

        save()
        eventsAdapter.invoke({ $0.remove(for: role) })
    }
}
extension KeysStorage {
    fileprivate class KeysContainer: Glossy {

        private struct Keys {
            public static let id = BaseDataType.Keys.ID
            public static let token = "Token"
            public static let rights = "Rights"
        }

        public let id: Long
        public let token: String
        public let rights: ApiRole

        public var keys: ApiKeys {
            return ApiKeys(id: id, token: token)
        }

        public init(keys: ApiKeys, rights: ApiRole){

            self.id = keys.id
            self.token = keys.token
            self.rights = rights
        }

        //MARK: Glossy
        public required init?(json: JSON) {

            self.id = (Keys.id <~~ json)!
            self.token = (Keys.token <~~ json)!
            self.rights = (Keys.rights <~~ json)!
        }
        public func toJSON() -> JSON? {

            return jsonify([

                Keys.id ~~> self.id,
                Keys.token ~~> self.token,
                Keys.rights ~~> self.rights
                ])
        }
    }
}
extension KeysStorage: IEventsEmitter {
    public typealias THandler = KeysStorageDelegate

    public func subscribe(guid: String, handler: KeysStorage.THandler, tag: String) {
        eventsAdapter.subscribe(guid: guid, handler: handler, tag: tag)
    }
    public func unsubscribe(guid: String) {
        eventsAdapter.unsubscribe(guid: guid)
    }
}
