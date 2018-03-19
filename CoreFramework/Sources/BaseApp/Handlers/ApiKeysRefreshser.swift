//
//  ApiKeysRefreshser.swift
//  BaseApp
//
//  Created by Алексей on 22.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class ApiKeysRefreshser {

    private static let tag = String.tag(ApiKeysRefreshser.self)
    private static let authApi = DependencyResolver.get(AuthMainApiService.self)
    private static let keysService = DependencyResolver.get(ApiKeyService.self)

    public static func launch() {

        guard let keys = keysService.keys else {
            return
        }

        let request = authApi.refresh(keys: keys)
        request.async(.background, completion: { response in

            if let update = response.data {
                Log.info(self.tag, "Successful refresh api keys for \(keysService.role)")
                keysService.update(by: update)

            } else if (response.statusCode != .ConnectionError) {
                Log.warning(self.tag, "Remove old api keys.")
                keysService.logout()

            } else {
                Log.warning(self.tag, "Not connection to server.")
            }
        })
    }
}
