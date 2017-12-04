//
//  ApiServices.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 04.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class ApiServices {

    public struct Auth {
        public static let main = AuthMainApiService(configs: configs)
    }
    public struct Menu {
        public static let summaries = MenuSummariesApiService(configs: configs)
    }
    public struct Notifications {
        public static let devices = NotificationsDevicesApiService(configs: configs, keys: keys)
    }
    public struct Places {
        public static let summaries = PlaceSummariesApiService(configs: configs)
    }
    public struct Users {
        public static let account = UserAccountApiService(configs: configs, keys: keys)
        public static let cards = UserCardsApiService(configs: configs, keys: keys)
        public static let change = UserChangeApiService(configs: configs, keys: keys)
        public static let orders = UserOrdersApiService(configs: configs, keys: keys)
    }

    private static var configs: ConfigsStorage {
        return ToolsServices.shared.configs
    }
    private static var keys: KeysStorage {
        return ToolsServices.shared.keys
    }
}
