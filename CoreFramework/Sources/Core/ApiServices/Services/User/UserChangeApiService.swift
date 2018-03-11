//
//  AccountUpdateUserApiService.swift
//  Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class UserChangeApiService: BaseApiService {

    public init(_ configs: ConfigsContainer, _ keys: ApiKeyService) {
        super.init(area: "User/Change", type: UserChangeApiService.self, configs: configs, keys: keys)
    }

}
