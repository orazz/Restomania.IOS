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
            305: to305
            ]


        for (build, migration) in migrations.sorted(by: { $0.key < $1.key }) {

            if (prevBuild < build) {
                migration()
            }
        }
    }
    private static func to305() {

        Log.Info(tag, "Apply migration for 305 build.")

        CacheServices.places.cache.clear()
        CacheServices.searchCards.cache.clear()

        LogicServices.shared.likes.clear()
    }
}
