//
//  AppSettings.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Gloss

public class AppSettings: Decodable {
    public let HostName: String
    public let ApiHostName: String
//    public let StatusPath: String
//    public let ReportsPath: String
//    public let UploadUrl: String
//    public let SettingsPath: String

    public let Debug: Bool

    public let DefaultSquareImage: String
    public let DefaultHDImage: String

    public let PaymentClient: BankClientType

    public init() {
        self.HostName = String.Empty
        self.ApiHostName = String.Empty

        self.Debug = false

        self.DefaultHDImage = String.Empty
        self.DefaultSquareImage = String.Empty

        self.PaymentClient = .TestClient
    }
    public required init(json: JSON) {
        self.HostName = ("HostName" <~~ json)!
        self.ApiHostName = ("ApiHostName" <~~ json)!
//        self.StatusPath = "StatusPath" <~~ json
//        self.ReportsPath = "ReportsPath" <~~ json
//        self.UploadUrl = "UploadUrl" <~~ json
//        self.SettingsPath = "SettingsPath" <~~ json

        self.Debug = ("Debug" <~~ json)!

        self.DefaultSquareImage = ("DefaultSquareImage" <~~ json)!
        self.DefaultHDImage = ("DefaultHDImage" <~~ json)!

        self.PaymentClient = ("PaymentClient" <~~ json)!
    }
}
