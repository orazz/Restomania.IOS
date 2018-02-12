//
//  KeysStorage.swift
//  Kuzina
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit
import CoreTools
import CoreDomains

public class KeysStorage: ApiKeyService {

    private let tag = String.tag(KeysStorage.self)

    private let configs: ConfigsContainer
    private let storage: LightStorage
    private let eventsAdapter: EventsAdapter<ApiKeyServiceDelegate>

    public init(_ configs: ConfigsContainer, _ storage: LightStorage) {

        self.configs = configs
        self.storage = storage
        eventsAdapter = EventsAdapter<ApiKeyServiceDelegate>(tag: tag)

        keys = storage.get(LightStorageKey.apiKeys)
    }

    public var role: ApiRole {
        return configs.appUserRole
    }
    public var keys: ApiKeys?

    public func update(by keys: ApiKeys) {

        self.keys = keys
        save()
    }
    public func logout() {

        keys = nil
        save()
    }
    private func save() {

        if let value = self.keys {
            storage.set(LightStorageKey.apiKeys, value: value)
        }
        else {
            storage.remove(LightStorageKey.apiKeys)
        }
    }


    public func subscribe(guid: String, handler: ApiKeyServiceDelegate, tag: String) {
        eventsAdapter.subscribe(guid: guid, handler: handler, tag: tag)
    }
    public func unsubscribe(guid: String) {
        eventsAdapter.unsubscribe(guid: guid)
    }
}

