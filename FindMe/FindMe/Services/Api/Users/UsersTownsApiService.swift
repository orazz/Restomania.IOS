//
//  UsersTownsApiService.swift
//  FindMe
//
//  Created by Алексей on 28.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class UsersTownsApiService: BaseApiService {

    public init(configs: ConfigsStorage, keys: KeysStorage) {
        super.init(area: "Users/Towns", configs: configs, tag: String.tag(UsersTownsApiService.self), keys: keys)
    }


    //MARK: Methods
    public func take() -> RequestResult<[Long]> {
        let parameters = self.CollectParameters(rights: .user)

        return self.client.GetLongRange(action: "Index", parameters: parameters)
    }
    public func update(towns: [Long]) -> RequestResult<Bool> {
        let parameters = self.CollectParameters(rights: .user, [
            "towns": towns
            ])

        return self.client.PutBool(action: "Update", parameters: parameters)
    }
}
