//
//  RefreshDataManager.swift
//  Kuzina
//
//  Created by Алексей on 24.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import CoreTools
import CoreDomains
import CoreApiServices
import BaseApp

public class RefreshManager {

    public static var shared = RefreshManager()

    private let tag = String.tag(RefreshManager.self)
    private let authApi = DependencyResolver.resolve(AuthMainApiService.self)
    private let keys = DependencyResolver.resolve(ApiKeyService.self)

    private init() {
    }

    public func checkApiKeys() {

        guard let keys = keys.keys else {
            return
        }

        let request = authApi.refresh(keys: keys)
        request.async(.background, completion: { response in

            if response.isSuccess,
                let update = response.data {

                if (keys != update) {
                    self.keys.update(by: update)
                    Log.info(self.tag, "Successful update keys for \(ApiRole.user)")
                }

            } else if (response.statusCode != .ConnectionError) {

                self.keys.logout()
                Log.warning(self.tag, "Remove old api keys.")
            }
        })
    }
}
