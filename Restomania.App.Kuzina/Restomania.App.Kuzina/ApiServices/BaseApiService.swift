//
//  BaseApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class BaseApiService: ILoggable {
    public var tag: String
    internal let _client: ApiClient
    private let _url: String

    public init(area: String, tag: String) {
        self._url = AppSummary.current.serverUrl

        self.tag = tag
        self._client = ApiClient(url: "\(_url)/mvcapi/\(area)", tag: tag)
    }

    internal func CollectParameters(_ values: Parameters? = nil) -> Parameters {
        var result = Parameters()

        if let values = values {
            for (key, value) in values {

                if let object = value as? Encodable {
                    result[key] = object.toJSON()
                } else {
                    result[key] = value
                }
            }
        }

        return result
    }
}
