//
//  Migrations.swift
//  FindMe
//
//  Created by Алексей on 13.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class Migrations {

    private static let tag = String.tag(Migrations.self)

    public static func apply() {

        let summary = AppSummary.shared
        if (summary.isFirstLaunch) {
            return
        }
        guard let prevBuild = summary.prevBuild else {
            return
        }

        let migrations = [
            231: migrateToV024100,
            ]



        for (build, migration) in migrations {

            if (prevBuild < build) {
                migration()
            }
        }
    }
    private static func migrateToV024100() {

        Log.Info(tag, "Apply migration for version 2.41.00")

        CacheServices.places.cache.clear()
        CacheServices.searchCards.cache.clear()

        LogicServices.shared.likes.clear()
    }
}
