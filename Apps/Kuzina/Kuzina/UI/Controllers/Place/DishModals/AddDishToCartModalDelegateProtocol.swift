//
//  AddDishToCartModalDelegateProtocol.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import CoreDomains

public protocol AddDishToCartModalDelegateProtocol: DishModalDelegateProtocol {

    func add(adding: Dish)
    func remove(adding: Dish)

    func select(variation: Variation)
}
