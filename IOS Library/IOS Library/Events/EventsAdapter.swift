//
//  EventsAdapter.swift
//  IOS Library
//
//  Created by Алексей on 11.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public typealias Action<THandler> = (THandler) throws -> Void
public class EventsAdapter<Handler> : ILoggable, IEventsEmitter {
    public typealias THandler = Handler

    public var Tag: String {
        return "EventsAdapter<\(_eventName)>"
    }

    private let _queue = DispatchQueue.global()

    private var _eventName: String
    private var _subscribers: [String : Subscriber<Handler>]

    private var _failLimit: Int
    private var _automatic: Bool
    private var _defaultAction: Action<Handler>?
    private var _triggered: Bool

    public init(name: String, failLimit: Int = -1) {
        _eventName = name
        _subscribers = [String: Subscriber<Handler>]()

        _failLimit = failLimit
        _automatic = false
        _defaultAction = nil
        _triggered = false
    }

    public func Setup(action: @escaping Action<Handler>, auto: Bool) {
        _defaultAction = action
        _automatic = auto
    }
    public func Subscribe(guid: String, handler: Handler, tag: String) {
        let subscriber = Subscriber(guid: guid, handler: handler, tag: tag)
        _subscribers[guid] = subscriber

        let message = "On \(_eventName) subscribe \(subscriber.Info)."
        Log.Debug(Tag, message)

        if (self._automatic && self._triggered) {
            Notify(subscriber, action:  _defaultAction!)
        }
    }
    public func Unsubscribe(guid: String) {
        let subscriber = _subscribers[guid]

        if (nil != subscriber) {
            _subscribers.removeValue(forKey: guid)
            Log.Debug(Tag, "From \(_eventName) unsubscribe \(subscriber!.Info).")
        }
    }
    private func ForceUnsubscribe(guid: String) {
        Unsubscribe(guid: guid)
        Log.Warning(Tag, "Force remove subscriber with GUID: \(guid).")
    }

    public func Trigger(action: Action<Handler>?) {
        var mainAction = action
        if (nil == mainAction) {
            if (nil != _defaultAction) {
                mainAction = _defaultAction
            } else {
                Log.Warning(Tag, "Can't trigger event without action.s")
                return
            }
        }

        Log.Debug(Tag, "Trigger \"\(_eventName)\" event.")
        for (_, subscriber) in _subscribers {
            Notify(subscriber, action: mainAction!)
        }

        _triggered = true
    }
    private func Notify(_ subscriber: Subscriber<Handler>, action: @escaping Action<Handler>) {
        _queue.async(execute: {() -> Void in

            let success = subscriber.Call(action: action, logger: self)

            if (!success) {
                if (-1 != self._failLimit && self._failLimit < subscriber.Fails) {
                    self.ForceUnsubscribe(guid: subscriber.Guid)
                }
            }
        })
    }
}
private class Subscriber<THandler> {
    public var Guid: String
    private var Tag: String
    private var Handler: THandler
    public var Fails: Int

    public var Info: String {
        return "\(Tag) with GUID: \(Guid)"
    }

    public init(guid: String, handler: THandler, tag: String) {
        self.Guid = guid
        self.Tag = tag
        self.Handler = handler
        self.Fails = 0
    }
    public func Call(action: Action<THandler>, logger: ILoggable) -> Bool {
        do {
            try action(self.Handler)
            Fails = 0

            return true
        } catch {
            Fails += 1
            Log.Error(logger.Tag, "Problem with \(self.Info)")

            return false
        }
    }

}
