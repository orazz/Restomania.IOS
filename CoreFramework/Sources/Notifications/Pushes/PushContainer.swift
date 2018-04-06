//
//  NotificationContainer.swift
//  CoreFramework
//
//  Created by Алексей on 16.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public typealias PushSource = [AnyHashable : Any]
public class PushContainer {

    private struct Keys {
        public static let id = "gcm.message_id"
        public static let apsContainer = "aps"
        public static let sound = "sound"
        public static let contentAvailable = "contentAvailble"
        public static let message = "message"
        public static let messageArgs = "messageArgs"
        public static let event = "event"
        public static let data = "data"
    }

    public private(set) var id: String
    public private(set) var sound: String
    public private(set) var message: String
    public private(set) var messageArgs: [String]
    public private(set) var event: NotificationEvents
    public private(set) var data: JSON?
    public private(set) var silent: Bool

    public static func tryParse(_ push: PushSource) -> PushContainer? {

        guard let json = push as? JSON else {
            return nil
        }

        let container = PushContainer()
        
        container.id = push[Keys.id] as? String ?? String.empty
        container.sound = (Keys.sound <~~ json) ?? "default"
        container.message = push[Keys.message] as? String ?? String.empty
        container.messageArgs = parseMessageArgs(json: json)
        container.event = parseEvent(json: json)
        container.data = parseSourceModel(json: json)

        let aps = json[Keys.apsContainer] as? JSON
        container.silent = nil != aps?[Keys.contentAvailable]

        return container
    }
    private init() {

        id = String.empty
        message = String.empty
        messageArgs = []
        silent = true
        event = .test
        data = nil
        sound = String.empty
    }

    private static func parseMessageArgs(json: JSON) -> [String] {

        guard let value = json[Keys.messageArgs] as? String,
            let content = value.data(using: .utf8) else {
                return []
        }

        do {
            let model = try JSONSerialization.jsonObject(with: content, options: [])
            return (model as? [String]) ?? []
        }
        catch {
            return []
        }
    }
    private static func parseEvent(json: JSON) -> NotificationEvents {

        guard let value = json[Keys.event] as? String,
            let source = Int(value),
            let result = NotificationEvents(rawValue: source) else {
                return .test
        }

        return result
    }
    private static func parseSourceModel(json: JSON) -> JSON {
        do {
            guard let data = json[Keys.data] as? String,
                let content = data.data(using: .utf8) else {
                    return [:]
            }

            let parsed = try JSONSerialization.jsonObject(with: content, options: [])
            return (parsed as? JSON) ?? [:]
        }
        catch {
            return [:]
        }
    }
}
