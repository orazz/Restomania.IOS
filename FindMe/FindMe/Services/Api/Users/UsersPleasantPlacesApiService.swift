//
//  UsersPleasantPlacesApiService.swift
//  FindMe
//
//  Created by Алексей on 28.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import AsyncTask

public class UsersPleasantPlacesApiService: BaseApiService {

    public init(configs: ConfigsStorage, keys: KeysStorage) {
        super.init(area: "Users/PleasantPlaces", configs: configs, tag: String.tag(UsersPleasantPlacesApiService.self), keys: keys)
    }


    //MARK: Methods
    public func take() -> RequestResult<[Long]> {
        let parameters = self.CollectParameters(rights: .user)

        return self.client.GetLongRange(action: "Index", parameters: parameters)
    }
    public func update(places: [Long]) -> RequestResult<Bool> {
        let parameters = self.CollectParameters(rights: .user, [
            "places": places
            ])

        return self.client.PutBool(action: "Update", parameters: parameters)
    }
}
