//
//  RefreshDataManager.swift
//  Kuzina
//
//  Created by Алексей on 24.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import CoreDomains

public class RefreshManager {

    public static var shared = RefreshManager()

    private let tag = String.tag(RefreshManager.self)
    private let authApi = ApiServices.Auth.main
    private let keys = ToolsServices.shared.keys

    private init() {}

    public func checkApiKeys() {

        guard let keys = keys.keys(for: .user) else {
            return
        }

        let request = authApi.refresh(keys: keys)
        request.async(.background, completion: { response in

            if response.isSuccess,
                let update = response.data {

                if (keys != update) {
                    self.keys.set(keys: update, for: .user)
                    Log.info(self.tag, "Successful update keys for \(ApiRole.user)")
                }

            } else if (response.statusCode != .ConnectionError) {

                self.keys.logout(for: .user)
                Log.warning(self.tag, "Remove old api keys.")
            }
        })
    }
}
