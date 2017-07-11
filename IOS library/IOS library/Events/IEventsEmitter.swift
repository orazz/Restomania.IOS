//
//  IEventsEmitter.swift
//  IOS Library
//
//  Created by Алексей on 11.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

public protocol IEventsEmitter
{
    associatedtype THandler
    
    func Subscribe(guid: String, handler: THandler, tag: String) -> Void
    func Unsubscribe(guid: String) -> Void
}
