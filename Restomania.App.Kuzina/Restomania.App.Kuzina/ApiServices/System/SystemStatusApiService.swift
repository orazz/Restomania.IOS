//
//  StatusSystemApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import IOSLibrary
import AsyncTask

public class SystemStatusApiService: BaseApiService {

    public init() {
        super.init(area: "System/Status", tag: "SystemStatusApiService")
    }

    public func IsAlive() -> RequestResult<Bool> {
        return _client.GetBool(action: "IsAlive")
    }
}