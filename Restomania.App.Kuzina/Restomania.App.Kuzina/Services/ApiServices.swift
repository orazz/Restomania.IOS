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
        public static var main: AuthMainApiService {
            return AuthMainApiService(configs: configs)
        }
    }
    public struct Menu {
        public static var summaries: MenuSummariesApiService {
            return MenuSummariesApiService(configs: configs)
        }
    }
    public struct Notifications {
        public static var devices: NotificationsDevicesApiService {
            return NotificationsDevicesApiService(configs: configs, keys: keys)
        }
    }
    public struct Places {
        public static var summaries: PlaceSummariesApiService {
            return PlaceSummariesApiService(configs: configs)
        }
    }
    public struct Users {
        public static var account: UserAccountApiService {
            return UserAccountApiService(configs: configs, keys: keys)
        }
        public static var cards: UserCardsApiService {
            return UserCardsApiService(configs: configs, keys: keys)
        }
        public static var change: UserChangeApiService {
            return UserChangeApiService(configs: configs, keys: keys)
        }
        public static var orders: UserOrdersApiService {
            return UserOrdersApiService(configs: configs, keys: keys)
        }
    }

    private static var configs: ConfigsStorage {
        return ToolsServices.shared.configs
    }
    private static var keys: KeysStorage {
        return ToolsServices.shared.keys
    }
}
