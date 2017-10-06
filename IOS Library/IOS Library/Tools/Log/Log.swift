//
//  Log.swift
//  IOS library
//
//  Created by Алексей on 10.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public class Log {
    public static var Messages: [LogMessage] = [LogMessage]()
    public static var IsDebug: Bool = true
    private static let _queue: DispatchQueue = DispatchQueue(label: "Log-Queue")

    public static func Debug(_ tag: String, _ message: String) {
        if (IsDebug) {
            Show(.debug, tag, message)
        }
    }
    public static func Info(_ tag: String, _ message: String) {
        Show(.info, tag, message)
    }
    public static func Warning(_ tag: String, _ message: String) {
        Show(.warning, tag, message)
    }
    public static func Error(_ tag: String, _ message: String) {
        Show(.error, tag, message)
    }

    private static func Show(_ type: LogMessageType, _ tag: String, _ message: String) {
        let logMessage = LogMessage(Date(), type, tag, message)

        _queue.async {
            Messages.append(logMessage)
        }
        
        print("\(logMessage)")
    }
}
