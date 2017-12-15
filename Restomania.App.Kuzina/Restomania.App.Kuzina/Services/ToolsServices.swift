//
//  ToolsServices.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 04.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class ToolsServices {

    public static let shared = ToolsServices()

    public let configs: ConfigsStorage
    public let properties: PropertiesStorage<PropertiesKey>
    public let keys: KeysStorage
    public let cartsService: CartService

    private init() {

        configs = ConfigsStorage(plistName: "Configs")
        properties = PropertiesStorage<PropertiesKey>()
        keys = KeysStorage()

        cartsService = CartService()
    }

    public func cart(for placeId: Long) -> Cart {
        return cartsService.get(for: placeId)
    }
}
