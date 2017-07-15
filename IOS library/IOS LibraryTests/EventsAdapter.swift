//
//  EventsAdapter.swift
//  IOS Library
//
//  Created by Алексей on 11.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import XCTest
@testable import IOSLibrary

public class EventsAdapterTests : XCTestCase
{
    typealias Action = () -> Void
    public func testEvents() -> Void
    {
        let waiter = expectation(description: "TestEventsAdapter")
        
        var counter = 0;
        let action = {
            counter += 1
        }
        
        let adapter = EventsAdapter<Action>(name: "Events")
        adapter.Setup(action: { (handler:Action) -> Void in handler()}, auto: true)
        
        let guid = Guid.New
        adapter.Subscribe(guid: guid, handler: action, tag: "1")
        adapter.Unsubscribe(guid: guid)
        adapter.Subscribe(guid: Guid.New, handler: action, tag: "2")
        adapter.Subscribe(guid: Guid.New, handler: action, tag: "3")
        
        adapter.Trigger(action: nil)
        
        
        DispatchQueue.global().async {
            XCTAssertEqual(2, counter)
            
            waiter.fulfill()
        }
        
        wait(for: [waiter], timeout: 10)
    }
}
