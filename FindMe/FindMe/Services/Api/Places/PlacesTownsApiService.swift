//
//  PlacesTownsApiService.swift
//  FindMe
//
//  Created by Алексей on 28.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import AsyncTask

public class PlacesTownsApiService: BaseApiService {

    public init(_ configs: ConfigsStorage) {
        super.init(area: "Places/Towns", configs: configs, tag: String.tag(PlacesTownsApiService.self))
    }

    //MARK: Methods
    public func all() -> RequestResult<[Town]> {
        return client.GetRange(action: "All", type: Town.self)
    }
}
