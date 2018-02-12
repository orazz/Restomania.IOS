//
//  PaymentCardStatus.swift
//  Kuzina
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public enum PaymentCardStatus: Int {
    case Proccessing = 1
    case Denied = 2
    case Ready = 3
    case Expired = 4
}
