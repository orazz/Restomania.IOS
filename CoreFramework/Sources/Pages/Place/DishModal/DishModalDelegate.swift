//
//  DishModalDelegate.swift
//  CoreFramework
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public protocol DishModalDelegate {

    func closeModal()
    func addToCart()

    var count: Int { get }
    var selectedVariation: Variation? { get }
    var selectedAddingsIds: [Long]  { get }
    var isAddNewDish: Bool { get }

    func add(adding dish: ParsedDish)
    func remove(adding dish: ParsedDish)

    func select(count: Int)
    func select(variation: Variation)
}
