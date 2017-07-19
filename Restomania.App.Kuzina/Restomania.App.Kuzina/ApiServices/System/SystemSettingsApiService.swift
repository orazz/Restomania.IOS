//
//  SettingsSystemApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import IOSLibrary
import AsyncTask

public class SystemSettingsApiService: BaseApiService {

    public init() {
        super.init(area: "System/Settings", tag: "SystemSettingsApiService")
    }

    public func All() -> RequestResult<AppSettings> {
        return _client.Get(action: "All", type: AppSettings.self)
    }
}
