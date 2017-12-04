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
    
    internal var tag: String
    internal let _client: ApiClient
    private let _url: String
    private let keysStorage: KeysStorage

    public init(area: String, tag: String) {
        self._url = AppSummary.current.serverUrl

        self.tag = tag
        self._client = ApiClient(url: "\(_url)/api/\(area)", tag: tag)
    }
    public init()


    internal override func CollectParameters(for role: ApiRole _ values: Parameters? = nil) -> Parameters {
        var parameters = super.CollectParameters(values)

        if let storage = keysStorage {
            let keys = storage.keys(for: role)
            parameters["keys"] = keys?.toJSON()
        }

        return parameters
    }
    internal func CollectParameters(_ values: Parameters? = nil) -> Parameters {
        var result = Parameters()

        if let values = values {
            for (key, value) in values {

                if let object = value as? Gloss.Encodable {
                    result[key] = object.toJSON()
                } else {
                    result[key] = value
                }
            }
        }

        return result
    }
}
