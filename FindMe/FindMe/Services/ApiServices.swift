//
//  ApiServices.swift
//  FindMe
//
//  Created by Алексей on 02.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public struct ApiServices {

    public struct Auth {
        public static var main: AuthMainApiService {
            return AuthMainApiService(configs: ToolsServices.shared.configs, keys: ToolsServices.shared.keys)
        }
    }

    public struct Users {
        public static var main: UsersMainApiService {
            return UsersMainApiService(configs: ToolsServices.shared.configs, keys: ToolsServices.shared.keys)
        }
        public static var auth: UsersAuthApiService {
            return UsersAuthApiService(ToolsServices.shared.configs)
        }
        public static var towns: UsersTownsApiService {
            return UsersTownsApiService(configs: ToolsServices.shared.configs, keys: ToolsServices.shared.keys)
        }
        public static var pleasantPlaces: UsersPleasantPlacesApiService {
            return UsersPleasantPlacesApiService(configs: ToolsServices.shared.configs, keys: ToolsServices.shared.keys)
        }
    }

    public struct Places {
        public static var main: PlacesMainApiService {
            return PlacesMainApiService(ToolsServices.shared.configs)
        }
        public static var searchCards: PlacesSearchCardsApiService {
            return PlacesSearchCardsApiService(ToolsServices.shared.configs)
        }
        public static var clients: PlacesClientsApiService {
            return PlacesClientsApiService(ToolsServices.shared.configs)
        }
        public static var actions: PlacesActionsApiService {
            return PlacesActionsApiService(ToolsServices.shared.configs)
        }
        public static var towns: PlacesTownsApiService {
            return PlacesTownsApiService(ToolsServices.shared.configs)
        }
    }
}
