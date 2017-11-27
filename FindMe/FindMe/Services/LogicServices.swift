//
//  ServicesFactory.swift
//  FindMe
//
//  Created by Алексей on 24.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class ServicesFactory {
    
    public static let shared = ServicesFactory()


    public let likes: LikesService
    public let positions: PositionsService
    public let backgroundPositions: BackgroundPositionsServices
    public let checkIns: CheckInService

    private init() {

        likes = LikesService()

        positions = PositionsService()
        backgroundPositions = BackgroundPositionsServices(tasksService: ToolsServices.shared.backgroundTasks)
        checkIns = CheckInService(positions: positions,
                                  backgroundPositions: backgroundPositions,
                                  searchCards: CacheServices.searchCards,
                                  configs: ToolsServices.shared.configs,
                                  keys: ToolsServices.shared.keys)
    }
}
