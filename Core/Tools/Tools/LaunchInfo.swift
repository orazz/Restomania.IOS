//
//  LaunchInfo.swift
//  CoreTools
//
//  Created by Алексей on 12.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

open class LaunchInfo {

//    private static let tag = String.tag(LaunchInfo.self)
//    public static func launch() {
//
//        Log.info(tag, "Launch app.")
//
//        let summary = AppSettings.shared
//
//        Log.info(tag, "Version: \(summary.version) (\(summary.build))")
//        Log.info(tag, "App key: \(summary.appKey).")
//
//        Log.info(tag, "Type: \(summary.type).")
//        switch summary.type {
//        case .Single:
//            Log.info(tag, "Place ID: \(summary.placeID!).")
//        case .Network:
//            Log.info(tag, "Places: \(summary.placeIDs!).")
//        default:
//            Log.info(tag, "App is agregator.")
//        }
//
//        Log.info(tag, "User role: \(summary.clientType).")
//        Log.info(tag, "Server url: \(summary.serverUrl).")
//        Log.info(tag, "")
//    }

    //Base
    public var version: String = "1.0.0"
    public var build: Int = 1
    public var prevVersion: String?
    public var prevBuild: Int?

    public var isUpdate: Bool {

        guard let prev = prevVersion else {
            return false
        }

        return prev != version
    }
    public var isCriticalUpdate: Bool = false

    private init(storage: LightStorage) {

        prevVersion = storage.get(LightStorageKey.appVersion)
        prevBuild = storage.get(LightStorageKey.appBuild)


        let configs = ConfigsStorage(plistName: "Info")
        version = configs.get(forKey: "CFBundleShortVersionString")!
        storage.set(LightStorageKey.appVersion, value: version)

        build = Int(configs.get(forKey: "CFBundleVersion")! as String)!
        storage.set(LightStorageKey.appBuild, value: build)


        guard let prevVersion = self.prevVersion,
            let _ = self.prevBuild else {
                return
        }
        if (!isUpdate) {
            return
        }


        // Check on critical update
        let parsedCurrent = parseVersion(version)
        let parsedPrev = parseVersion(prevVersion)
        isCriticalUpdate = parsedCurrent.0 > parsedPrev.0
    }
    private func parseVersion(_ version: String) -> (Int, Int, Int) {

        var splitted = version.components(separatedBy: CharacterSet.init(charactersIn: ".- "))
        
        while (splitted.count != 3) {
            splitted.append("")
        }

        return (Int(splitted[0])!,
                Int(splitted[1]) ?? 0,
                Int(splitted[2]) ?? 0)
    }
}
