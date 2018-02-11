//
//  BackgroundTaskManager.swift
//  FindMe
//
//  Created by Алексей on 04.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class BackgroundTasksService {

    public static let shared = BackgroundTasksService()

    private let _tag = String.tag(BackgroundTasksService.self)
    private let _application = UIApplication.shared
    private var _tasksRange: [UIBackgroundTaskIdentifier] = []


    private init() {}

    public func new() -> UIBackgroundTaskIdentifier {

        var result = UIBackgroundTaskInvalid

        result = _application.beginBackgroundTask(expirationHandler: {

            Log.debug(self._tag, "Background task #\(result) expired.")

            self.end(task: result)
        })

        if (result != UIBackgroundTaskInvalid) {
            self._tasksRange.append(result)
            Log.info(_tag, "Start background task #\(result).")
        }

        return result
    }
    public func end(task: UIBackgroundTaskIdentifier) {

        if (task == UIBackgroundTaskInvalid) {
            return
        }

        _application.endBackgroundTask(task)
        remove(task)

        Log.debug(_tag, "End background task #\(task).")
    }
    public func endAllBackgroundTasks() {

        while !_tasksRange.isEmpty {
            end(task: _tasksRange.first!)
        }
    }
    private func remove(_ identifier: UIBackgroundTaskIdentifier) {

        for i in 0..<_tasksRange.count {

            let task = _tasksRange[i]
            if (identifier == task) {

                _tasksRange.remove(at: i)
                break
            }
        }
    }
}
