//
//  CachePlaceSummariesService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import AsyncTask
import Gloss

public class CachePlaceSummariesService {

    private var _data: [PlaceSummary]

    public init() {
        _data = [PlaceSummary]()
    }

    public var hasData: Bool {
        return 0 != _data.count
    }
    public var localData: [PlaceSummary] {
        return _data
    }

}
