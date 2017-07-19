//
//  ReportsSystemApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import IOSLibrary
import AsyncTask

public class SystemReportsApiService: BaseApiService {

    public init() {
        super.init(area: "System/Reports", tag: "SystemReportsApiService")
    }

    public func Add(report: RemoteBugReport) -> RequestResult<RemoteBugReport> {
        let parameters = CollectParameters([
                "data": report
            ])

        return _client.Post(action: "Add", type: RemoteBugReport.self, parameters: parameters)
    }
}
