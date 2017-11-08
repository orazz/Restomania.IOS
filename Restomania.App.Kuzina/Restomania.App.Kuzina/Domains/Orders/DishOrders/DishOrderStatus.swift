//
//  DishOrderStatus.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public enum DishOrderStatus: Int {
    case Processing = 1
    case WaitingPayment = 2
    case Making = 3
    case Prepared = 4
    case Completed = 5
    case PaymentFail = 6
    case CanceledByUser = 7
    case CanceledByPlace = 8
}
