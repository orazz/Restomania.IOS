//
//  Migrations.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 30.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class Migrations {

    private static let tag = String.tag(Migrations.self)

    public static func apply() {

        let summary = AppSettings.shared
        guard let prevBuild = summary.prevBuild else {
            return
        }

        let migrations = [
            842: to842
        ]

        for (build, migration) in migrations.sorted(by: { $0.key < $1.key }) {

            if (prevBuild < build) {

                Log.Info(tag, "Apply migration for \(build) build.")
                migration()
            }
        }
    }
    private static func to842() {
        CacheServices.menus.clear()
    }
}
