//
//  BackgroundPositionsServices.swift
//  FindMe
//
//  Created by Алексей on 29.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class BackgroundPositionsServices: NSObject {

    private let _circlePeriod = 120.0
    private let _workPeriod = 10.0

    private let _tag = String.tag(BackgroundPositionsServices.self)
    private let _guid = Guid.new
    private var _task = UIBackgroundTaskInvalid
    private let _application = UIApplication.shared
    private var _circleTimer: Timer? = nil
    private var _workTimer: Timer? = nil

    private let _tasksService: BackgroundTasksService
    private var _sourceService: PositionsService

    public init(tasksService: BackgroundTasksService) {

        _tasksService = tasksService
        _sourceService = PositionsService()
        _sourceService.requestPermission(always: true)

        super.init()

        subscribe()
        reset()
    }
    private func subscribe() {

        _sourceService.subscribe(guid: _guid, handler: self, tag: _tag)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enterToBackground),
                                               name: Notification.Name.UIApplicationDidEnterBackground,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enterToForeground),
                                               name: Notification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
    }

    public var lastPosition: PositionsService.Position? {
        return _sourceService.lastPosition
    }
    public var isInForeground: Bool {
        return _application.applicationState == .active
    }
    public var isInBackground: Bool {
        return _application.applicationState == .background
    }



    //MARK: UI Circle
    @objc private func enterToForeground() {

        Log.info(_tag, "Turn off background location service.")

        reset()
    }
    @objc private func enterToBackground() {

        Log.info(_tag, "Turn on background location service.")

        _task = _tasksService.new()
        Timer.scheduledTimer(timeInterval: 10.0,
                             target: self,
                             selector: #selector(restartTracking),
                             userInfo: nil, repeats: false)
    }


    @objc private func restartTracking() {

        Log.debug(_tag, "Restart location updates.")

        resetTimers()
        _circleTimer = Timer.scheduledTimer(timeInterval: _circlePeriod,
                                            target: self,
                                            selector: #selector(restartTracking),
                                            userInfo: nil,
                                            repeats: false)
        _workTimer = Timer.scheduledTimer(timeInterval: _workPeriod,
                                          target: self,
                                          selector: #selector(stopTracking),
                                          userInfo: nil,
                                          repeats: false)



        let oldTask = _task
        _task = _tasksService.new()
        _tasksService.end(task: oldTask)

        _sourceService.requestPermission(always: true)
        _sourceService.startTracking()
    }
    @objc private func stopTracking() {

        Log.debug(_tag, "Go to sleep updates of location.")

        _workTimer?.invalidate()
        _workTimer = nil

        _sourceService.stopTracking()
    }
    private func reset() {

        resetTimers()

        _sourceService.stopTracking()
        _tasksService.end(task: _task)
    }
    private func resetTimers() {

        _workTimer?.invalidate()
        _workTimer = nil

        _circleTimer?.invalidate()
        _circleTimer = nil
    }
}



//MARK: PositionServiceDelegate
extension BackgroundPositionsServices: PositionServiceDelegate {

    public func updateLocation(positions: [PositionsService.Position]) {

        Log.debug(_tag, "Update location.")
    }
}



//MARK: IEventsEmitter
extension BackgroundPositionsServices: IEventsEmitter {
    public typealias THandler = PositionServiceDelegate

    public func subscribe(guid: String, handler: THandler, tag: String) {
        _sourceService.subscribe(guid: guid, handler: handler, tag: tag)
    }
    public func unsubscribe(guid: String) {
        _sourceService.unsubscribe(guid: guid)
    }
}
