//
//  AppConfigs.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 21.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class AppSummary: ILoggable {

    public static var shared: AppSummary!
    public static func initialize() {
        shared = AppSummary()
        Log.Info(shared.tag, "Lanuch app with type \(AppSummary.shared.type).")
    }

    public var tag: String {
        return "AppSummary"
    }
    public let type: AppType
    public let clientType: ClientAppType
    public let serverUrl: String

    public var version: String
    public var build: Int
    public var isNewVersion: Bool
    public var isCriticalUpdate: Bool

    //Date & Time formats
    public struct DataTimeFormat {

        public static let dateWithTime = "HH:mm dd/MM/yyyy"
        public static let shortTime = "HH:mm"
        public static let shortDate = "dd/MM"
    }

    public var placeID: Long?
    public var placeIDs: [Long]?

    private init() {
        let configs = ConfigsStorage(plistName: "Configs")

        self.type = AppType(rawValue: configs.get(forKey: ConfigKeys.AppType).value as! String) ?? .Aggregator
        self.clientType = ClientAppType(rawValue: configs.get(forKey: ConfigKeys.ClientAppType).value as! String) ?? .User
        self.serverUrl = configs.get(forKey: ConfigKeys.ServerUrl).value as! String

        //Version
        self.version = "1.0.0"
        self.build = 1
        self.isNewVersion = false
        self.isCriticalUpdate = false
        checkVersion()

        //IDs
        self.placeID = nil
        self.placeIDs = nil
        setupID(from: configs)
    }
    private func checkVersion() {
        let configs = ConfigsStorage(plistName: "Info")
        self.version = configs.get(forKey: "CFBundleShortVersionString").value as! String
        self.build = Int(configs.get(forKey: "CFBundleVersion").value as! String)!

        let storage = PropertiesStorage<PropertiesKey>()
        let lastVersion = storage.getString(.AppVersion)
        let lastBuild = storage.getInt(.AppBuild)

        //Update versions and build
        storage.set(.AppVersion, value: version)
        storage.set(.AppBuild, value: build)

        if (!lastVersion.hasValue || !lastBuild.hasValue) {
            return
        }

        // Check on new version
        if (build > lastBuild.value) {
            self.isNewVersion = true
        } else {
            self.isNewVersion = false
            return
        }

        // Check on critical update
        let parsedCurrent = parseVersion(version)
        let parsedLast = parseVersion(lastVersion.value)

        if ((parsedCurrent.0 > parsedLast.0) ||
            (parsedCurrent.1 > parsedLast.1)) {

            self.isCriticalUpdate = true
        } else {

            self.isCriticalUpdate = false
        }
    }
    private func parseVersion(_ version: String) -> (Int, Int, Int) {

        let range = version.split(separator: ".").map(String.init)

        return (Int(range[0])!,
                Int(range[1])!,
                Int(range[2])!)
    }
    private func setupID(from configs: ConfigsStorage) {
        if (type == .Single) {
            let value = configs.get(forKey: ConfigKeys.PlaceID).value as! String

            self.placeID = Long(value)!
            self.placeIDs = nil

        } else if (type == .Network) {
            self.placeID = nil

            do {
                let ids = configs.get(forKey: ConfigKeys.PlacesIDs).value as! String
                let data = ids.data(using: .utf8)!
                let range = try JSONSerialization.jsonObject(with: data, options: []) as! [Long]

                self.placeIDs = range
            } catch {
                self.placeIDs = [Long]()
            }

        }
    }
}
