//
//  AppConfigs.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 21.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class AppSettings {

    private static let tag = String.tag(AppSettings.self)
    public static var shared = AppSettings()
    public static func launch() {

        Log.info(tag, "Launch app.")

        let summary = AppSettings.shared

        Log.info(tag, "Version: \(summary.version) (\(summary.build))")
        Log.info(tag, "App key: \(summary.appKey).")

        Log.info(tag, "Type: \(summary.type).")
        switch summary.type {
            case .Single:
                Log.info(tag, "Place ID: \(summary.placeID!).")
            case .Network:
                Log.info(tag, "Places: \(summary.placeIDs!).")
            default:
                Log.info(tag, "App is agregator.")
        }

        Log.info(tag, "User role: \(summary.clientType).")
        Log.info(tag, "Server url: \(summary.serverUrl).")
        Log.info(tag, "")
    }

    //Configs
    public let configs: ConfigsStorage
    public let appKey: String
    public let type: AppType
    public let clientType: ApiRole
    public let serverUrl: String
    public var placeID: Long?
    public var placeIDs: [Long]?

    //Base
    public var version: String = "1.0.0"
    public var build: Int = 1
    public var prevVersion: String?
    public var prevBuild: Int?
    public var isNewVersion: Bool = false
    public var isCriticalUpdate: Bool = false

    private init() {

        configs = ConfigsStorage(plistName: "Configs")
        appKey = configs.get(forKey: ConfigKeys.appKey)!
        type = AppType(rawValue: configs.get(forKey: ConfigKeys.appType)!)!
        clientType = AppUserRole(rawValue: configs.get(forKey: ConfigKeys.appUserRole)!)!.role
        serverUrl = configs.get(forKey: ConfigKeys.serverUrl)!
        parseIds(from: configs)

        parseVersionAndBuild()
    }
    private func parseVersionAndBuild() {
        let configs = ConfigsStorage(plistName: "Info")
        version = configs.get(forKey: "CFBundleShortVersionString")!
        build = Int(configs.get(forKey: "CFBundleVersion")! as String)!

        let storage = PropertiesStorage<PropertiesKey>()
        prevVersion = storage.getString(.appVersion).unwrapped
        prevBuild = storage.getInt(.appBuild).unwrapped

        //Update versions and build
        storage.set(.appVersion, value: version)
        storage.set(.appBuild, value: build)

        guard let prevVersion = self.prevVersion,
            let prevBuild = self.prevBuild else {
                return
        }

        isNewVersion = self.build > prevBuild
        if (!isNewVersion) {
            return
        }

        // Check on critical update
        let parsedCurrent = parseVersion(version)
        let parsedPrev = parseVersion(prevVersion)
        isCriticalUpdate = parsedCurrent.0 > parsedPrev.0
    }
    private func parseVersion(_ version: String) -> (Int, Int, Int) {

        let range = version.components(separatedBy: CharacterSet.init(charactersIn: ".- "))

        return (Int(range[0])!,
                Int(range[1]) ?? 0,
                Int(range[2]) ?? 0)
    }
    private func parseIds(from configs: ConfigsStorage) {
        if (type == .Single) {
            let value: String = configs.get(forKey: ConfigKeys.placeId)!

            self.placeID = Long(value)!
            self.placeIDs = nil

        } else if (type == .Network) {
            self.placeID = nil

            do {
                let ids: String = configs.get(forKey: ConfigKeys.placesIds)!
                let data = ids.data(using: .utf8)!
                let range = try JSONSerialization.jsonObject(with: data, options: []) as! [Long]

                self.placeIDs = range
            } catch {
                self.placeIDs = [Long]()
            }

        }
    }
}
