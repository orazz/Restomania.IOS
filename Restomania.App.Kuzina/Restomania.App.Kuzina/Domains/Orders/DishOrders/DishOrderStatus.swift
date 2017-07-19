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
    case Completed = 4
    case PaymentFail = 5
    case CanceledByUser = 6
    case CanceledByPlace = 7
}
