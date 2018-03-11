//
//  ConfigKey.swift
//  CoreTools
//
//  Created by Алексей on 12.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
open class ConfigKey: RawRepresentable {
    public typealias RawValue = String



    public static let appKey = ConfigKey(rawValue: "AppKey")
    public static let serverUrl = ConfigKey(rawValue: "ServerUrl")

    public static let appType = ConfigKey(rawValue: "AppType")
    public static let appUserRole = ConfigKey(rawValue: "AppUserRole")

    public static let placeId = ConfigKey(rawValue: "PlaceId")
    public static let chainId = ConfigKey(rawValue: "ChainId")

    public static let paymentSystem = ConfigKey(rawValue: "PaymentSystem")
    public static let currency = ConfigKey(rawValue: "Currency")


    public static let vkAppId = ConfigKey(rawValue: "VkAppId")


    public let rawValue: String
    public required init(rawValue : String) {
        self.rawValue = rawValue
    }
}
