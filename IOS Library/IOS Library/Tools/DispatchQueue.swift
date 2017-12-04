//
//  DispatchQueue.swift
//  IOSLibrary
//
//  Created by Алексей on 29.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import AsyncTask

extension AsyncQueue {

    public static func createForControllerLoad(for tag: String) -> AsyncQueue {
        return AsyncQueue.custom(DispatchQueue.createControllerLoadQueue(for: tag))
    }
    public static func createForApi(for tag: String) -> AsyncQueue {
        return AsyncQueue.custom(DispatchQueue.createApiQueue(for: tag))
    }
}
extension DispatchQueue {
    public static func createControllerLoadQueue(for tag: String) -> DispatchQueue {
        return DispatchQueue.init(label: "\(tag)-controller-load", qos: DispatchQoS.userInitiated, attributes: [], autoreleaseFrequency: .inherit, target: nil)
    }
    public static func createApiQueue(for tag: String) -> DispatchQueue {
        return DispatchQueue.init(label: "\(tag)-api-requests", qos: DispatchQoS.utility, attributes: [], autoreleaseFrequency: .inherit, target: nil)
    }
}
