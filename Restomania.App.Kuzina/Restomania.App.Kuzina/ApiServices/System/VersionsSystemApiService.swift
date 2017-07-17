//
//  VersionsSystemApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import IOSLibrary
import AsyncTask

public class VersionsSystemApiService: BaseApiService {
    public init() {
        super.init(area: "System/Versions", tag: "VersionsSystemApiService")
    }

    public func Last() -> Task<RequestResult<Version>> {
        let parameters = [
            "platform": Platform.IOS
        ]

        return _client.Get(action: "Last", type: Version.self, parameters: parameters as? Parameters)
    }
    public func LastCritical() -> Task<RequestResult<Version>> {
        let parameters = [
            "platform": Platform.IOS
        ]

        return _client.Get(action: "LastCritical", type: Version.self, parameters: parameters as? Parameters)
    }
}
