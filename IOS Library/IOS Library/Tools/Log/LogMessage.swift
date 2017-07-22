//
//  LogMessage.swift
//  IOS library
//
//  Created by Алексей on 10.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public enum LogMessageType {
    case Debug
    case Info
    case Warning
    case Error
}
public class LogMessage: CustomStringConvertible {
    public let Time: Date
    public let `Type`:LogMessageType
    public let Tag: String
    public let Message: String

    private static let _formatter: DateFormatter = InitFormatter()
    private class func InitFormatter() -> DateFormatter {
        let result = DateFormatter()
        result.dateFormat = "dd/MM HH:mm:ss:SSS"

        return result
    }

    public var description: String {
        let time = LogMessage._formatter.string(from: Time)
        let type = "\(Type)".characters.first!

        return "[\(time)] [\(type)] <\(Tag)> \(Message)"
    }

    public init(_ time: Date, _ type: LogMessageType, _ tag: String, _ message: String) {
        Time = time
        Type = type
        Tag = tag
        Message = message
    }
}
