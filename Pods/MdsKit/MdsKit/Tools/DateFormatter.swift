//
//  DateFormatter.swift
//  MdsKit
//
//  Created by Алексей on 18.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation

extension DateFormatter {
    public convenience init(for format: String) {
        self.init()

        dateFormat = format
    }
}
