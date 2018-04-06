//
//  PlaceMenuDelegate.swift
//  CoreFramework
//
//  Created by Алексей on 18.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public protocol PlaceMenuDelegate: PlaceDelegate {

    var placeId: Long { get }
    func takeMenu() -> ParsedMenu?
    func takeCart() -> CartService

    func select(category: Long)
    func select(dish: Long)
    func addToCart(_ dishId: Long, count: Int, with addings: [Long], use variationId: Long?)

    func goToCart()
    func goToPlace()
}
