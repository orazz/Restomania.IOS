//
//  LogMessage.swift
//  IOS library
//
//  Created by Алексей on 10.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public enum LogMessageType {
    case debug
    case info
    case warning
    case error
}
public class LogMessage: CustomStringConvertible {
    public let Time: Date
    public let type:LogMessageType
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
        let stringType = "\(type)"

        return "[\(time)] [\(Array(stringType).first!)] <\(Tag)> \(Message)"
    }

    public init(_ time: Date, _ type: LogMessageType, _ tag: String, _ message: String) {
        Time = time
        self.type = type
        Tag = tag
        Message = message
    }
}
