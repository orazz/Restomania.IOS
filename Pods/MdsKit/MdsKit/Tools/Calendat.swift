//
//  Calendat.swift
//  MdsKit
//
//  Created by Алексей on 18.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation

extension Calendar {
    public static var utcCurrent: Calendar {

        var calendar = Calendar.current
        calendar.timeZone = TimeZone.utc

        return calendar
    }
}
