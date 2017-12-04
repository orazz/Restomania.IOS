//
//  RefreshDataManager.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 24.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class RefreshManager {

    public static var shared = RefreshManager()

    private let tag = String.tag(RefreshManager.self)
    private let authApiClient = AuthMainApiService()
    private let keysService: KeysStorage

    private init() {
        keysService = ServicesManager.shared.keys
    }

    public func checkApiKeys() {

        guard let keys = keysService.keys(for: .user) else {
            return
        }

        let request = authApiClient.refresh(keys: keys)
        request.async(.background, completion: { response in

            if response.isSuccess,
                let update = response.data {

                self.keysService.set(keys: update, for: .user)
                Log.Info(self.tag, "Successful update keys for \(ApiRole.user)")

            } else if (response.statusCode != .ConnectionError) {

                self.keysService.logout(for: .user)
                Log.Warning(self.tag, "Remove old api keys.")
            }
        })
    }
}
