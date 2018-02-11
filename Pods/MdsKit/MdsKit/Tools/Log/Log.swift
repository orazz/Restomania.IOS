//
//  Log.swift
//  MdsKit
//
//  Created by Алексей on 10.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public class Log {

    public static var messages = [LogMessage]()
    public static var isDebug = true
    private static let queue = DispatchQueue(label: "Log-Queue")

    public static func debug(_ tag: String, _ message: String) {
        if (isDebug) {
            show(.debug, tag, message)
        }
    }
    public static func info(_ tag: String, _ message: String) {
        show(.info, tag, message)
    }
    public static func warning(_ tag: String, _ message: String) {
        show(.warning, tag, message)
    }
    public static func error(_ tag: String, _ message: String) {
        show(.error, tag, message)
    }
    private static func show(_ type: LogMessageType, _ tag: String, _ message: String) {
        let logMessage = LogMessage(Date(), type, tag, message)

        queue.async {
            messages.append(logMessage)
            print(logMessage.description, terminator: "\n")
        }
    }
}
