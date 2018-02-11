//
//  PlacesActionsApiService.swift
//  FindMe
//
//  Created by Алексей on 27.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class PlacesActionsApiService: BaseApiService {

    public init(_ configs: ConfigsStorage) {
        super.init(area: "Places/Actions", configs: configs, tag: String.tag(PlacesActionsApiService.self))
    }

    //MARK: Methods
    public func all(for placeId:Long, with args: SelectParameters) -> RequestResult<[Action]> {
        let parameters = CollectParameters([
            "placeId": placeId,
            "arguments": args
            ])

        return client.GetRange(action: "All", type: Action.self, parameters: parameters)
    }
    public func find(_ actionId: Long) -> RequestResult<Action> {
        let parameters = CollectParameters([
            "actionId": actionId
            ])

        return client.Get(action: "Find", type: Action.self, parameters: parameters)
    }
}


