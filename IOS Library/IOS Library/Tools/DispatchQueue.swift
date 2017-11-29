//
//  DispatchQueue.swift
//  IOSLibrary
//
//  Created by Алексей on 29.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

extension DispatchQueue {

    public static func createApiQueue(for tag:String) -> DispatchQueue {
        return DispatchQueue.init(label: "\(tag)-apiReqeust", qos: DispatchQoS.utility, attributes: [], autoreleaseFrequency: .inherit, target: nil)
    }
}
