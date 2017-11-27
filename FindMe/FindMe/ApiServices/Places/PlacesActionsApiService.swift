//
//  PlacesActionsApiService.swift
//  FindMe
//
//  Created by Алексей on 27.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import AsyncTask

public class PlacesActionsApiService: BaseApiService {

    public init(_ configs: ConfigsStorage) {
        super.init(area: "Places/Actions", configs: configs, tag: String.tag(PlacesActionsApiService.self))
    }

    //MARK: Methods
    public func all(with args: SelectParameters) -> RequestResult<[Action]> {

        let parameters = CollectParameters([
            "args": args
            ])

        return _client.GetRange(action: "All", type: Action.self, parameters: parameters)
    }
}


