//
//  AuthMainApiService.swift
//  FindMe
//
//  Created by Алексей on 29.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class AuthMainApiService: BaseApiService {

    public init(configs: ConfigsStorage, keys: IKeysStorage) {
        super.init(area: "Auth", configs: configs, tag: String.tag(AuthMainApiService.self), keys: keys)
    }


    //MARK: Methods
    public func refresh(for rights: ApiRole) -> RequestResult<ApiKeys> {
        
        let parameters = self.CollectParameters(rights: rights)

        return self.client.Get(action: "Refresh", type: ApiKeys.self, parameters: parameters)
    }
}
