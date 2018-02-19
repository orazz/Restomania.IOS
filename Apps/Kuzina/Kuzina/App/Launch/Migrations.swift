//
//  Migrations.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 30.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import CoreTools

public class Migrations {

    private static let tag = String.tag(Migrations.self)

    public static func apply(with info: LaunchInfo) {

        guard let prevBuild = info.prevBuild else {
            return
        }

        let migrations: [Int: Trigger] = [:]

        for (build, migration) in migrations.sorted(by: { $0.key < $1.key }) {

            if (prevBuild < build) {

                Log.info(tag, "Apply migration for \(build) build.")
                migration()
            }
        }
    }
}
