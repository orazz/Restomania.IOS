//
//  NotificationEvents.swift
//  CoreFramework
//
//  Created by Алексей on 16.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation

public enum NotificationEvents: Int {

    case test = 1

    case adminFailedWebJob = 1001
    case adminReportedBug = 1002

    case placeAddedForPlace = 2001
    case placeAddedForAdmin = 2002
    case placeChangedStatusForPlace = 2003
    case placeChangedStatusForAdmin = 2004
    case placeResetPassword = 2005

    case userAddedForUser = 3001
    case userAddedForAdmin = 3002
    case userBannedUser = 3003
    case userResetPassword = 3004
    case userAddedPaymentCard = 3005

    case dishOrderAddedForPlace = 4001
    case dishOrderAddedForUser = 4002
    case dishOrderChangedStatusForPlace = 4003
    case dishOrderChangedStatusForUser = 4004
    case dishOrderPaymentFailForPlace = 4005
    case dishOrderPaymentFailForUser = 4006
    case dishOrderPaymentCompleteForPlace = 4007
    case dishOrderPaymentCompleteForUser = 4008
    case dishOrderIsPreparedForUser = 4009
    case dishOrderNotProcessLongTime = 4010
    case dishOrderClientWillComeSoon = 4011

    case marketingNewAction = 5001
    case marketingNewPlace = 5002
    case marketingNewAppUpdate = 5003
}
