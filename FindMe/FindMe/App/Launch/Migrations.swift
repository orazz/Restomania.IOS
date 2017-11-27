//
//  Migrations.swift
//  FindMe
//
//  Created by Алексей on 13.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public class Migrations {

    public static func apply() {

        let summary = AppSummary.shared

        if (summary.isFirstLaunch) {
            return
        }
    }
}
