//
//  AppSettings.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Gloss

public class AppSettings: Gloss.Decodable {

    public struct Keys {
        public static let hostname = "HostName"
        public static let apiHostname = "ApiHostName"
        public static let debug = "Debug"
        public static let paymentClient = "PaymentClient"
    }

    public let HostName: String
    public let ApiHostName: String
    public let Debug: Bool
    public let PaymentClient: BankClientType

    public init() {

        self.HostName = String.empty
        self.ApiHostName = String.empty
        self.Debug = false
        self.PaymentClient = .TestClient
    }

    // MARK: Decodable
    public required init(json: JSON) {

        self.HostName = (Keys.hostname <~~ json)!
        self.ApiHostName = (Keys.apiHostname <~~ json)!
        self.Debug = (Keys.debug <~~ json)!
        self.PaymentClient = (Keys.paymentClient <~~ json)!
    }
}
