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
    internal var _keys: IKeysStorage? = nil
    
    private var _url: String
    
    public init(area: String, configs: ConfigsStorage, tag: String, keys:IKeysStorage? = nil) {

        self._url = configs.get(forKey: ConfigsKey.serverUrl).value as! String
        self._client = ApiClient(url: "\(_url)/api/\(area)", tag: tag)
        self._keys = keys

        super.init()
    }
    
    
    //MARK: Build parameters
    internal func CollectParameters(_ values: Parameters? = nil) -> Parameters {
        var result = Parameters()
        
        if let values = values {
            for (key, value) in values {

                if let array = value as? [Gloss.Encodable] {

                    result[key] = array.map({ $0.toJSON() })
                }
                else if let object = value as? Gloss.Encodable {
                    
                    result[key] = object.toJSON()
                }
                else {
                    
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
