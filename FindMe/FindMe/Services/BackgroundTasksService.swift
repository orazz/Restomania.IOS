//
//  BackgroundTaskManager.swift
//  FindMe
//
//  Created by Алексей on 04.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class BackgroundTasksService {

    public static let shared = BackgroundTasksService()

    private let _tag = String.tag(BackgroundTasksService.self)
    private var _masterTaskId: UIBackgroundTaskIdentifier
    private var _tasksRange: [UIBackgroundTaskIdentifier]


    public init() {

        _masterTaskId = UIBackgroundTaskInvalid
        _tasksRange = []
    }

    public func beginNew() -> UIBackgroundTaskIdentifier {

        let application = UIApplication.shared

        var result = UIBackgroundTaskInvalid

        result = application.beginBackgroundTask(expirationHandler: {

            Log.Debug(self._tag, "Background task #\(result) expired.")
        })

        if (_masterTaskId == UIBackgroundTaskInvalid) {

            self._masterTaskId = result
            Log.Info(_tag, "Start master task #\(result).")
        }
        else {

            self._tasksRange.append(result)
            Log.Info(_tag, "Start background task.")
            endBackgroundTasks()
        }

        return result
    }
    public func end(task: UIBackgroundTaskIdentifier) {

        if (task == UIBackgroundTaskInvalid) {
            return
        }

        if (_masterTaskId == task) {
            endAllBackgroundTasks()
        }
        else {
            UIApplication.shared.endBackgroundTask(task)
        }
    }
    public func endBackgroundTasks() {
        drainList(all: false)
    }
    public func endAllBackgroundTasks() {
        drainList(all: true)
    }
    private func drainList(all:Bool) {

        let application = UIApplication.shared

        var count = _tasksRange.count
        if (!all) {
            count = count - 1
        }

        for _ in 0..<count {

            let identifier = _tasksRange.first!
            Log.Debug(_tag, "End background task #\(identifier).")
            application.endBackgroundTask(identifier)
            _tasksRange.removeFirst()
        }

        if (!_tasksRange.isEmpty) {

            Log.Debug(_tag, "Keep task with id #\(_tasksRange.first!).")
        }

        if (all) {

            Log.Debug(_tag, "Not more background tasks running.")
            application.endBackgroundTask(_masterTaskId)
            _masterTaskId = UIBackgroundTaskInvalid
        }
        else {

            Log.Debug(_tag, "Kept master background task id #\(_masterTaskId)")
        }

    }

    private func removeTask(_ identifier: UIBackgroundTaskIdentifier) {

        for i in 0..._tasksRange.count {

            let task = _tasksRange[i]
            if (identifier == task) {

                _tasksRange.remove(at: i)
                break
            }
        }
    }
}
