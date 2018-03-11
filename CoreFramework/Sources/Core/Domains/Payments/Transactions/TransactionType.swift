//
//  TransactionType.swift
//  CoreDomains
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public enum TransactionType: Int {
    case Quick = 1
    case Reserve = 2
    case RecurringBase = 3
    case QuickRecurringBase = 5
    case RecurringPayment = 4
}
