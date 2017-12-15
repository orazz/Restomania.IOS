//
//  PushNotificationsManager.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 23.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import AsyncTask
import IOSLibrary
import UserNotifications

public class PushNotificationsManager {

    public static let shared = PushNotificationsManager()

    private let tag = String.tag(PushNotificationsManager.self)
    private let _apiClient = ApiServices.Notifications.devices
    private let _keysStorage = ToolsServices.shared.keys
    private let _properties = ToolsServices.shared.properties
    private var _token: String?

    private init() {

        let token = _properties.getString(.PushDeviceToken)
        if (token.hasValue) {
            register(token.value)
        }
    }
    public func processMessage(push: [AnyHashable: Any]) {

//        let task = Task {
//
////            let aps = push.index(forKey: "aps")
////            let pair = push[aps!]
////
////            let alertContainer = pair.value
////            let container = alertContainer as! [String:Any]
////            let data = container["data"] as! [String: Any]
////
////            let event = NotificationEvents(rawValue: data["Event"] as! Int)
////            let modelID = data["ID"] as! Long
//        }
//        task.async(.background, completion: {
//
//            Log.Debug(self.tag, "Complete process push-notification.")
//        })

        Log.Debug(self.tag, "Complete process push-notification.")
    }

    public func requestPermissions() {

        let application = UIApplication.shared

        let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
    }
    public func completeRequestToPushNotifications(token: Data?, error: Error? = nil) {

        if let error = error {

            Log.Error(tag, "User not get permissions on send push notifications.")
            Log.Error(tag, String(describing: error))
        }

        if let token = token {

            Log.Info(tag, "Get device token for send push notifications.")

            let parsed = token.map ({ String(format: "%02.2hhx", $0) }).joined()
            register(parsed)
        }
    }

    public func register(_ token: String) {

        Log.Debug(tag, "Register device with token: \(token)")

       if (!_keysStorage.isAuth(for: .user)) {
            return
        }

        let locale = Locale.preferredLanguages.first ?? "en"

        if (_token == token) {
            return
        }

        _token = token

        let task = _apiClient.Register(role: .user, token: token, locale: locale)
        task.async(.background, completion: { result in

            if (result.statusCode == .OK) {
                Log.Info(self.tag, "Complete success register device for push notification.")
            }

            self._properties.set(.PushDeviceToken, value: token)
        })
    }
}
private enum NotificationEvents: Int {

    case TestExample = 1

    //Admin
    case AdminFailedWebJob = 11
    case AdminReportedBug = 12

    //Booking
    case BookingsAddedForPlace = 21
    case BookingsAddedForUser = 22
    case BookingsChangedStatusForPlace = 23
    case BookingsChangedStatusForUser = 24

    //DishOrder
    case DishOrdersAddedForPlace = 31
    case DishOrdersAddedForUser = 32
    case DishOrdersChangedStatusForPlace = 33
    case DishOrdersChangedStatusForUser = 34

    //Place
    case PlaceAddedForPlace = 41
    case PlaceAddedForAdmin = 42
    case PlaceChangedStatusForPlace = 43
    case PlaceChangedStatusForAdmin = 44
    case PlaceResetedPassword = 45
    case PlaceListedTodayOrders = 46
    case PlaceListedTodayBookings = 47

    //Review
    case ReviewAddedForUser = 51
    case ReviewAddedForPlace = 52
    case ReviewAddedForAdmin = 53
    case ReviewChangedForUser = 54
    case ReviewChangedForPlace = 55
    case ReviewChangedForAdmin = 56
    case ReviewChangedStatusForUser = 57
    case ReviewChangedStatusForAdmin = 58

    //User
    case UserAddedForUser = 61
    case UserAddedForAdmin = 62
    case UserBannedUser = 63
    case UserResetedPassword = 64
    case UserAddedPaymentCard = 65
    case UserReportedPayment = 66
}
