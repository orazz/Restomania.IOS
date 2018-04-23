//
//  ApiServices.swift
//  CoreFramework
//
//  Created by Алексей on 04.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import Swinject

open class ApiServices {

    open static func register(in container: Container) {

        //Auth
        container.register(AuthMainApiService.self, factory: { r in AuthMainApiService(r.configs) })

        //Menu
        container.register(MenuSummariesApiService.self, factory: { r in MenuSummariesApiService(r.configs) })
        container.register(MenuStoplistApiService.self, factory: { r in MenuStoplistApiService(r.configs) })

        //Notifications
        container.register(NotificationsDevicesApiService.self, factory: { r in NotificationsDevicesApiService(r.configs, r.keys, r.resolve(LaunchInfo.self)!) })

        //Places
        container.register(PlaceSummariesApiService.self, factory: { r in PlaceSummariesApiService(r.configs) })

        //Users
        container.register(UserAccountApiService.self, factory: { r in UserAccountApiService(r.configs, r.keys) })
        container.register(UserAuthApiService.self, factory: { r in UserAuthApiService(r.configs, r.keys) })
        container.register(UserChangeApiService.self, factory: { r in UserChangeApiService(r.configs, r.keys) })
        container.register(UserCardsApiService.self, factory: { r in UserCardsApiService(r.configs, r.keys) })
        container.register(UserOrdersApiService.self, factory: { r in UserOrdersApiService(r.configs, r.keys) })
    }
}
extension Resolver {
    fileprivate var configs: ConfigsContainer {
        return self.resolve(ConfigsContainer.self)!
    }
    fileprivate var keys: ApiKeyService {
        return self.resolve(ApiKeyService.self)!
    }
}
