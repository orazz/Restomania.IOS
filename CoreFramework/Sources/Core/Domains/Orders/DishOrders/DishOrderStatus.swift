//
//  DishOrderStatus.swift
//  CoreDomains
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public enum DishOrderStatus: Int {

    case processing = 1
    case approved = 2
    case isPaid = 3
    case isPrepared = 4
    case completed = 5
    case paymentFail = 6
    case canceledByUser = 7
    case canceledByPlace = 8
}
