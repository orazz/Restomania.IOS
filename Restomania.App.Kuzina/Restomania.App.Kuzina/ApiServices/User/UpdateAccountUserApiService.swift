//
//  AccountUpdateUserApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import AsyncTask
import IOSLibrary

public class UpdateAccountUserApiService: BaseAuthApiService {

    public init(storage: IKeysStorage) {
        super.init(storage: storage, rights: .User, area: "User/UpdateAccount", tag: "UpdateAccountUserApiService")
    }

}
