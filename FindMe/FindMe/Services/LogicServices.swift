//
//  ServicesFactory.swift
//  FindMe
//
//  Created by Алексей on 24.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class LogicServices {
    
    public static let shared = LogicServices()

    public let likes: LikesService
    public let towns: SelectedTownsService
    public let positions: PositionsService
    public let backgroundPositions: BackgroundPositionsServices
    public let checkIns: CheckInService

    private init() {

        likes = LikesService()
        towns = SelectedTownsService()

        positions = PositionsService()
        backgroundPositions = BackgroundPositionsServices(tasksService: ToolsServices.shared.backgroundTasks)
        checkIns = CheckInService(positions: positions,
                                  backgroundPositions: backgroundPositions,
                                  searchCards: CacheServices.searchCards,
                                  configs: ToolsServices.shared.configs,
                                  keys: ToolsServices.shared.keys)
    }
    
    public func load() {
        
        likes.load()
        towns.load()
    }
}
