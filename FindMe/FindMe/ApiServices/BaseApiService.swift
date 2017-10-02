//
//  BaseApiService.swift
//  FindMe
//
//  Created by Алексей on 19.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss


public class BaseApiService: NSObject {
    
    internal var _client: ApiClient!
    
    private var _url: String!
    private var _keys: IKeysStorage? = nil
    
    
    public init(area: String) {
        
        super.init()
        
        self._url = AppSummary.shared.serverUrl
        self._client = ApiClient(url: "\(_url)/api/\(area)", tag: tag)
    }
    public convenience init(area: String, storage: IKeysStorage) {
        self.init(area: area)
        
        _keys = storage
    }
    
    
    //MARK: Build parameters
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
    internal func CollectParameters(rights: ApiRights, _ values: Parameters? = nil) -> Parameters {
        
        var parameters = CollectParameters(values)
        
        if let keys = _keys?.keys(for: rights) {
            
            parameters["keys"] = keys.toJSON()
        }
    
        return parameters
    }
}
