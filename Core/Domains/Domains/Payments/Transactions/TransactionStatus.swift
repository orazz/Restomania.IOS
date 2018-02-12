//
//  TransactionStatus.swift
//  CoreDomains
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public enum TransactionStatus: Int {
    case Clean = -1
    case Registered = 1
    case Reserved = 2
    case Authorized = 3
    case Processing = 4
    case Failed = 5
    case Success = 6
    case Reversed = 7
}
