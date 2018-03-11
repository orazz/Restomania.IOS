//
//  NotificationEvents.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 16.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation

public enum NotificationEvents: Int {

    case TestExample = 1

    case AdminFailedWebJob = 1001
    case AdminReportedBug = 1002

    case PlaceAddedForPlace = 2001
    case PlaceAddedForAdmin = 2002
    case PlaceChangedStatusForPlace = 2003
    case PlaceChangedStatusForAdmin = 2004
    case PlaceResetPassword = 2005

    case UserAddedForUser = 3001
    case UserAddedForAdmin = 3002
    case UserBannedUser = 3003
    case UserResetPassword = 3004
    case UserAddedPaymentCard = 3005

    case DishOrderAddedForPlace = 4001
    case DishOrderAddedForUser = 4002
    case DishOrderChangedStatusForPlace = 4003
    case DishOrderChangedStatusForUser = 4004
    case DishOrderPaymentFailForPlace = 4005
    case DishOrderPaymentFailForUser = 4006
    case DishOrderPaymentCompleteForPlace = 4007
    case DishOrderPaymentCompleteForUser = 4008
    case DishOrderIsPreparedForUser = 4009
}
