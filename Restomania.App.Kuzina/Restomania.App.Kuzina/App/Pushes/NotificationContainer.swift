//
//  NotificationContainer.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 16.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class NotificationContainer {

    private struct Keys {
        public static let apsContainer = "aps"
        public static let alertContainer = "alert"
        public static let message = "message"
        public static let messageArgs = "messageArgs"
        public static let event = "event"
        public static let model = "model"
    }

    public private(set) var message: String
    public private(set) var messageArgs: [String]
    public private(set) var allowNotify: Bool
    public private(set) var event: NotificationEvents
    public private(set) var model: JSON

    public static func tryParse(_ data: [AnyHashable : Any]) -> NotificationContainer? {

        guard let aps = data.valueForKeyPath(keyPath: Keys.apsContainer) as? [String:Any],
            let eventSource = aps[Keys.event] as? Int,
            let event = NotificationEvents(rawValue: eventSource) else {
                return nil
        }

        let container = NotificationContainer()
        container.message = aps[Keys.message] as? String ?? String.empty
        container.messageArgs = aps[Keys.messageArgs] as? [String] ?? []
        container.allowNotify = nil != aps[Keys.alertContainer]
        container.event = event
        container.model = aps[Keys.model] as? JSON ?? [:]

        return container
    }
    private init() {
        message = String.empty
        messageArgs = []
        allowNotify = true
        event = .TestExample
        model = [:]
    }
}
