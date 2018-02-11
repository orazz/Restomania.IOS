//
//  IEventsEmitter.swift
//  MdsKit
//
//  Created by Алексей on 11.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

public protocol IEventsEmitter {
    associatedtype THandler

    func subscribe(guid: String, handler: THandler, tag: String)
    func unsubscribe(guid: String)
}
