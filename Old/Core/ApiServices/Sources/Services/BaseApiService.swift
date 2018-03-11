//
//  BaseApiService.swift
//  Kuzina
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import Gloss
import CoreDomains
import CoreTools

public class BaseApiService {

    internal var tag: String
    internal let client: ApiClient
    internal let configs: ConfigsContainer
    internal let keysStorage: ApiKeyService?

    public init(area: String, type: AnyObject.Type, configs: ConfigsContainer, keys: ApiKeyService? = nil) {

        self.tag = String.tag(type)
        self.client = ApiClient(url: "\(configs.serverUrl)/api/\(area)", tag: tag)
        self.configs = configs
        self.keysStorage = keys
    }

    internal func CollectParameters(_ values: Parameters? = nil) -> Parameters {
        var result = Parameters()

        if let values = values {
            for (key, value) in values {

                if let object = value as? JSONEncodable {
                    result[key] = object.toJSON()
                } else {
                    result[key] = value
                }
            }
        }

        if let keys = keysStorage?.keys {
            result["keys"] = keys.toJSON()
        }

        return result
    }
}
