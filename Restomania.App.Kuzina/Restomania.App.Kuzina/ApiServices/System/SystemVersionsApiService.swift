//
//  VersionsSystemApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import IOSLibrary
import AsyncTask

public class SystemVersionsApiService: BaseApiService {
    
    public init() {
        super.init(area: "System/Versions", tag: "SystemVersionsApiService")
    }

    public func Last() -> Task<RequestResult<Version>> {
        let parameters = CollectParameters([
                "platform": Platform.IOS
            ])

        return _client.Get(action: "Last", type: Version.self, parameters: parameters)
    }
    public func LastCritical() -> Task<RequestResult<Version>> {
        let parameters = CollectParameters([
                "platform": Platform.IOS
            ])

        return _client.Get(action: "LastCritical", type: Version.self, parameters: parameters)
    }
}
