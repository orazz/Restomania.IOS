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
        public static let contentAvailable = "contentAvailble"
        public static let message = "message"
        public static let messageArgs = "messageArgs"
        public static let event = "event"
        public static let data = "data"
    }

    public private (set) var id: String
    public private(set) var message: String
    public private(set) var messageArgs: [String]
    public private(set) var allowNotify: Bool
    public private(set) var event: NotificationEvents
    public private(set) var data: JSON?

    public static func tryParse(_ push: PushSource) -> PushContainer? {

        guard let eventSource = push[Keys.event] as? Int,
                let event = NotificationEvents(rawValue: eventSource) else {
            return nil
        }

        let container = PushContainer()
        
        container.id = push[Keys.id] as? String ?? String.empty
        container.message = push[Keys.message] as? String ?? String.empty
        container.messageArgs = push[Keys.messageArgs] as? [String] ?? []
        container.allowNotify = !(push[Keys.contentAvailable] as? Bool ?? false)
        container.event = event
        container.data = push[Keys.data] as? JSON

        return container
    }
    private init() {

        id = String.empty
        message = String.empty
        messageArgs = []
        allowNotify = true
        event = .test
        data = nil
    }
}
