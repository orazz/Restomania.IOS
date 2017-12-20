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

public class BaseApiService {

    internal var tag: String
    internal let client: ApiClient
    private let keysStorage: KeysStorage?

    public init(area: String, type: AnyObject.Type, configs: ConfigsStorage, keys: KeysStorage? = nil) {

        self.tag = String.tag(type)
        let url = configs.get(forKey: ConfigKeys.ServerUrl)
        self.client = ApiClient(url: "\(url)/api/\(area)", tag: tag)
        self.keysStorage = keys
    }

    internal func CollectParameters(for role: ApiRole, _ values: Parameters? = nil) -> Parameters {
        var result = CollectParameters(values)

        if let storage = keysStorage {
            let keys = storage.keys(for: role)
            result["keys"] = keys?.toJSON()
        }

        return result
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
