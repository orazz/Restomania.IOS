//
//  AppSummary.swift
//  FindMe
//
//  Created by Алексей on 24.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class AppSummary {
    
    public static let shared = AppSummary()

    private let tag = String.tag(AppSummary.self)
    public let serverUrl: String
    
    public var version: String
    public var build: Int
    public var prevVersion: String?
    public var prevBuild: Int?
    public var isUpdate: Bool
    public var isImportantUpdate: Bool

    public var isFirstLaunch: Bool {
        return nil == prevVersion
    }

    private init() {
        
        let configs = ToolsServices.shared.configs
        self.serverUrl = configs.get(forKey: ConfigsKey.serverUrl).value as! String
        
        //Version
        self.version = "1.0.0"
        self.build = 1
        self.isUpdate = false
        self.isImportantUpdate = false
        checkVersion()
    }
    private func checkVersion() {
        
        let configs = ConfigsStorage(plistName: "Info")
        
        self.version = configs.get(forKey: "CFBundleShortVersionString").value as! String
        self.build = Int(configs.get(forKey: "CFBundleVersion").value as! String)!
        
        
        let storage = PropertiesStorage<PropertiesKey>();
        let prevVersion = storage.getString(.appVersion)
        let prevBuild = storage.getInt(.appBuild)
        
        //Update versions and build
        storage.set(.appVersion, value: version)
        storage.set(.appBuild, value: build)
        
        if (!prevVersion.hasValue || !prevBuild.hasValue) {

            self.prevVersion = nil
            self.prevBuild = nil

            return
        }
        
        // Check on new version
        if (build > prevBuild.value) {
            
            self.isUpdate = true
        } else {
            
            self.isUpdate = false
            return
        }
        
        // Check on critical update
        let parsedCurrent = parseVersion(version)
        let parsedLast = parseVersion(prevVersion.value)
        
        if ((parsedCurrent.0 > parsedLast.0) ||
            (parsedCurrent.1 > parsedLast.1)) {
            
            self.isImportantUpdate = true
        } else {
            
            self.isImportantUpdate = false
        }

        self.prevVersion = prevVersion.value
        self.prevBuild = prevBuild.value
    }
    private func parseVersion(_ version: String) -> (Int, Int, Int) {

        let range = version.components(separatedBy: CharacterSet(charactersIn: " .-"))
        
        return (Int(range[0])!,
                Int(range[1]) ?? 0,
                Int(range[2]) ?? 0)
    }



    public func launchApp() {

        Log.Info(tag, "Init AppSummary.")
        Log.Info(tag, "App version: \(version)")
        Log.Info(tag, "App build: \(build)")

        if let prevVersion = prevVersion {
            Log.Info(tag, "App previous version: \(prevVersion)")
        }
        if let prevBuild = prevBuild {
            Log.Info(tag, "App previous build: \(prevBuild)")
        }
    }
}
