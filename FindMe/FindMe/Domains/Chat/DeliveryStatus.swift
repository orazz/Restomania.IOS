//
//  DeliveryStatus.swift
//  FindMe
//
//  Created by Алексей on 23.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation

public enum DeliveryStatus: Int
{
    case sending = 0
    case processing = 1
    case isDelivered = 2
    case isRead = 3
}
