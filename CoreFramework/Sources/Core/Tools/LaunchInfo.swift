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

    private let tag = String.tag(LaunchInfo.self)

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

    public init(_ storage: LightStorage) {

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


    public func displayToLog() {
        Log.info(tag, "Version: \(version) (\(build))")
    }
}
