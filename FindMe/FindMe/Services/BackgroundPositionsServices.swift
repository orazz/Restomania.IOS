//
//  BackgroundPositionsServices.swift
//  FindMe
//
//  Created by Алексей on 29.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class BackgroundPositionsServices: NSObject, IEventsEmitter, PositionServiceDelegate {
    public typealias THandler = PositionServiceDelegate

    private static let _circlePeriod = 30.0
    private static let _workPeriod = 10.0

    private let _tag = String.tag(BackgroundPositionsServices.self)
    private let _guid = Guid.new
    private var _task = UIBackgroundTaskInvalid
    private let _application = UIApplication.shared
    private var _circleTimer: Timer? = nil
    private var _workTimer: Timer? = nil

    private let _tasksService: BackgroundTasksService
    private let _sourceService: PositionsService

    public init(tasksService: BackgroundTasksService) {

        _tasksService = tasksService
        _sourceService = PositionsService()

        super.init()

        _sourceService.subscribe(guid: _guid, handler: self, tag: _tag)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enterToBackground),
                                               name: Notification.Name.UIApplicationDidEnterBackground,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enterToForeground),
                                               name: Notification.Name.UIApplicationWillEnterForeground,
                                               object: nil)

        reset()
    }

    private var isInForeground: Bool {
        return _application.applicationState == .active
    }
    private var isInBackground: Bool {
        return _application.applicationState == .background
    }



    //MARK:
    @objc private func enterToBackground() {

        Log.Info(_tag, "Turn on background location service.")

        _task = _tasksService.beginNew()
        _sourceService.startTracking()

        //Process full work circle
        _circleTimer = Timer.scheduledTimer(timeInterval: BackgroundPositionsServices._circlePeriod,
                                            target: self,
                                            selector: #selector(restartUpdates),
                                            userInfo: nil,
                                            repeats: false)

        //Process work timer
        _workTimer = Timer.scheduledTimer(timeInterval: BackgroundPositionsServices._workPeriod,
                                          target: self,
                                          selector: #selector(stopWork),
                                          userInfo: nil,
                                          repeats: false)
    }
    @objc private func enterToForeground() {

        Log.Info(_tag, "Turn off background location service.")

        reset()
    }



    //MARK: IEventsEmitter
    public func subscribe(guid: String, handler: PositionServiceDelegate, tag: String) {
        _sourceService.subscribe(guid: guid, handler: handler, tag: tag)
    }
    public func unsubscribe(guid: String) {
        _sourceService.unsubscribe(guid: guid)
    }



    //MARK: PositionServiceDelegate
    public func updateLocation(positions: [PositionsService.Position]) {

        if (!isInBackground) {
            return
        }

    }
    @objc private func restartUpdates() {

        Log.Debug(_tag, "Restart location updates.")

        _circleTimer?.invalidate()
        _circleTimer = nil


        _sourceService.startTracking()

        _task = _tasksService.beginNew()
    }
    @objc private func stopWork() {

        Log.Debug(_tag, "Go to sleep updates of location.")

        _workTimer?.invalidate()
        _workTimer = nil

        _sourceService.stopTracking()

        _task = _tasksService.beginNew()
    }
    private func reset() {

        _workTimer?.invalidate()
        _workTimer = nil

        _circleTimer?.invalidate()
        _circleTimer = nil

        _sourceService.stopTracking()
        _tasksService.end(task: _task)
    }
}
