//
//  CartUpdateProtocol.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import CoreApiServices


public protocol CartServiceDelegate {
    func cart(_ cart: CartService, change dish: AddedOrderDish)
    func cart(_ cart: CartService, remove dish: AddedOrderDish)
}
extension CartServiceDelegate {
    public func cart(_ cart: CartService, change dish: AddedOrderDish) {}
    public func cart(_ cart: CartService, remove dish: AddedOrderDish) {}
}

