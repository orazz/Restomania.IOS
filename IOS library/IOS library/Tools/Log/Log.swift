//
//  Log.swift
//  IOS library
//
//  Created by Алексей on 10.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation


public class Log
{
    public static var Messages:[LogMessage] = [LogMessage]()
    
    public static func Debug(_ tag: String, _ message: String)
    {
        Show(.Debug, tag, message)
    }
    public static func Info(_ tag: String, _ message: String)
    {
        Show(.Info, tag, message)
    }
    public static func Warning(_ tag: String, _ message: String)
    {
        Show(.Warning, tag, message)
    }
    public static func Error(_ tag: String, _ message: String)
    {
        Show(.Error, tag, message)
    }
    
    private static func Show(_ type: LogMessageType, _ tag: String, _ message: String) -> Void
    {
        let logMessage = LogMessage(Date(), type, tag, message)
        
        Messages.append(logMessage)
        print("log: \(logMessage)")
    }
}

