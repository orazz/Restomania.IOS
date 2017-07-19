//
//  BookingStatus.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public enum BookingStatus: Int {
    case Processing = 1
    case Approved = 2
    case Completed = 3
    case CanceledByUser = 4
    case CanceledByPlace = 5
}
