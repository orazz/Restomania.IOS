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
            305: to305,
            329: to329,
            395: to395,
            536: to536,
            ]
        
        for (build, migration) in migrations.sorted(by: { $0.key < $1.key }) {

            if (prevBuild < build) {

                Log.info(tag, "Apply migration for \(build) build.")
                migration()
            }
        }
    }
    private static func to305() {

        CacheServices.places.cache.clear()
        CacheServices.searchCards.cache.clear()

        LogicServices.shared.likes.clear()
    }
    private static func to329() {
        CacheServices.searchCards.cache.clear()
    }
    private static func to395() {
        CacheServices.chatDialogs.clear()
    }
    private static func to536() {
        CacheServices.chatMessages.clear()
    }
}
