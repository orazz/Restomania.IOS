//
//  AppConfigs.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 21.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class AppConfigs {

    public static let current = AppConfigs()

    public let type: AppType
    public let serverUrl: String
    public let theme: ThemeSettings

    public var version: String
    public var build: Int
    public var isNewVersion: Bool
    public var isCriticalUpdate: Bool

    public var placeID: Long?
    public var placeIDs: [Long]?

    private init() {
        let configs = ConfigsStorage(plistName: "Configs")

        //Type
        self.type = AppType(rawValue: configs.Get(.AppType).value as! String) ?? .Aggregator

        //ServerUrl
        self.serverUrl = configs.Get(.ServerUrl).value as! String

        //Theme
        self.theme = ThemeSettings()

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
        self.version = configs.Get(forKey: "CFBundleShortVersionString").value as! String
        self.build = Int(configs.Get(forKey: "CFBundleVersion").value as! String)!

        let lastVersion = PropertiesStorage.getString(.AppVersion)
        let lastBuild = PropertiesStorage.getInt(.AppBuild)

        //Update versions and build
        PropertiesStorage.set(.AppVersion, value: version)
        PropertiesStorage.set(.AppBuild, value: build)

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

        let range = version.characters.split(separator: ".").map(String.init)

        return (Int(range[0])!,
                Int(range[1])!,
                Int(range[2])!)
    }
    private func setupID(from configs: ConfigsStorage) {
        if (type == .Single) {
            let value = configs.Get(.PlaceID).value as! String

            self.placeID = Long(value)!
            self.placeIDs = nil

        } else if (type == .Network) {
            self.placeID = nil

            do {
                let ids = configs.Get(.PlacesIDs).value as! String
                let data = ids.data(using: .utf8)!
                let range = try JSONSerialization.jsonObject(with: data, options: []) as! [Long]

                self.placeIDs = range
            } catch {
                self.placeIDs = [Long]()
            }

        }
    }
}
extension ConfigsStorage {
    public func Get(_ key: ConfigKeys) -> OptionalValue<Any> {
        return self.Get(forKey: key.rawValue)
    }
}
