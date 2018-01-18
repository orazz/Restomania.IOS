//
//  TimeZone.swift
//  IOSLibrary
//
//  Created by Алексей on 18.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation

extension TimeZone {
    public static var utc: TimeZone {
        return TimeZone(identifier: "UTC")!
    }
}
