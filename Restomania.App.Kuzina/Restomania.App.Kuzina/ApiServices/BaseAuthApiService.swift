//
//  BaseAuthApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class BaseAuthApiService: BaseApiService {
    private let _keyStorage: IKeysStorage
    private let _rights: AccessRights

    public init(storage: IKeysStorage, rights: AccessRights, area: String, tag: String) {
        self._keyStorage = storage
        self._rights = rights

        super.init(area: area, tag: tag)
    }

    internal override func CollectParameters(_ values: Parameters? = nil) -> Parameters {
        var parameters = super.CollectParameters(values)

        let keys = _keyStorage.GetKeysFor(rights: _rights)
        parameters["keys"] = keys?.toJSON()

        return parameters
    }
}