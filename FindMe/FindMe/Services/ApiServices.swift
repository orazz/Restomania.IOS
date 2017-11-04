//
//  ApiServices.swift
//  FindMe
//
//  Created by Алексей on 02.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public struct ApiServices {

    public struct Users {
        public static var main: UsersMainApiService {
            return UsersMainApiService(configs: ServicesFactory.configs, keys: ServicesFactory.keys)
        }
        public static var auth: UsersAuthApiService {
            return UsersAuthApiService(ServicesFactory.configs)
        }
    }

    public struct Places {
        public static var main: PlacesMainApiService {
            return PlacesMainApiService(ServicesFactory.configs)
        }
        public static var clients: PlacesClientsApiService {
            return PlacesClientsApiService(ServicesFactory.configs)
        }
    }
}
