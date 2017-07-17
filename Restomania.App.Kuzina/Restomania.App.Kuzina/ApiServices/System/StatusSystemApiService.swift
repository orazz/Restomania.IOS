//
//  StatusSystemApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import IOSLibrary
import AsyncTask

public class StatusSystemApiService: BaseApiService {
    public init() {
        super.init(area: "System/Status", tag: "StatusSystemApiService")
    }

    public func IsAlive() -> Task<RequestResult<Bool>> {
        return _client.GetBool(action: "IsAlive")
    }
}
