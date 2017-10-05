//
//  CheckInService.swift
//  FindMe
//
//  Created by Алексей on 04.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class CheckInService: NSObject, PositionServiceDelegate {

    private let _tag = String.tag(CheckInService.self)
    private let _guid = Guid.new
    private let _positions: PositionsService
    private let _searchCards: SearchPlaceCardsCacheService

    public init(positions: PositionsService, searchCards: SearchPlaceCardsCacheService) {

        self._positions = positions
        self._searchCards = searchCards

        super.init()

        self._positions.subscribe(guid: _guid, handler: self, tag: _tag)
    }


    //MARK: PositionServiceDelegate
    public func updateLocation(position: [PositionsService.Position]) {

    }
}
