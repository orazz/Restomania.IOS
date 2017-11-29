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
    public func check(for rights: ApiRole) -> RequestResult<Bool> {
        
        let parameters = self.CollectParameters(rights: rights)

        return self.client.GetBool(action: "Check", parameters: parameters)
    }
}
