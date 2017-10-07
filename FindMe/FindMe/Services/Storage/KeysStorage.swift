//
//  IKeysStorage.swift
//  FindMe
//
//  Created by Алексей on 24.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

internal class KeysStorage: IKeysStorage {

    private let _tag = String.tag(KeysStorage.self)
    private let _fileClient: FSOneFileClient
    private var _keys: [KeysContainer] = []

    public init() {

        _fileClient = FSOneFileClient(filename: "keys.json", inCache: false, tag: _tag)
        _keys = load()

        Log.Info(_tag, "Load service.")
    }
    private func load() -> [KeysContainer] {

        if _fileClient.isExist,
           let content = _fileClient.loadData() {

            do {
                return try JSONSerialization.parseRange(data: content)
            }
            catch {
                _fileClient.save(data: "[]")
            }
        }

        return []
    }
    private func save() {

        do {
            let data = try JSONSerialization.serialize(data: _keys)
            _fileClient.save(data: data)
        }
        catch {

            Log.Error(_tag, "Problem with save keys to file.")
        }
    }
    
    
    //MARK: IKeysStorage
    public func keys(for rights: ApiRights) -> ApiKeys? {

        return _keys.find({ rights == $0.rights })?.keys
    }
    public func set(for rights: ApiRights, keys: ApiKeys) {

        _keys.append(KeysContainer(keys: keys, rights: rights))

        save()
    }
    public func isAuth(rights: ApiRights) -> Bool {
        return nil != keys(for: rights)
    }

    private class KeysContainer: Glossy{

        private struct Keys {

            public static let id = "ID"
            public static let token = "Token"
            public static let rights = "Rights"
        }

        public let id: Long
        public let token: String
        public let rights: ApiRights

        public var keys: ApiKeys {
            return ApiKeys(id: id, token: token)
        }

        public init(keys: ApiKeys, rights: ApiRights){

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