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

    public static let current = PushNotificationsManager()

    private let tag = "PushNotificationsManager"
    private let _apiClient: OpenDevicesApiService
    private let _keysStorage: IKeysStorage
    private let _currentAppAccessRights: AccessRights

    private init() {

        _apiClient = OpenDevicesApiService()
        _keysStorage = ServicesManager.current.keysStorage

        switch(AppSummary.current.clientType) {
            case .User:
                _currentAppAccessRights = .User
                break

            case .Place:
                _currentAppAccessRights = .Place
                break

            case .Admin:
                _currentAppAccessRights = .Admin
                break
        }

        let token = PropertiesStorage.getString(.PushDeviceToken)
        if (token.hasValue) {
            register(deviceToken: token.value)
        }
    }
    public func processMessage(push: [AnyHashable: Any]) {

        let task = Task {

//            let aps = push.index(forKey: "aps")
//            let pair = push[aps!]
//
//            let alertContainer = pair.value
//            let container = alertContainer as! [String:Any]
//            let data = container["data"] as! [String: Any]
//
//            let event = NotificationEvents(rawValue: data["Event"] as! Int)
//            let modelID = data["ID"] as! Long
        }
        task.async(.background, completion: {

            Log.Debug(self.tag, "Complete process push-notification.")
        })
    }

    public func requestPushNotifications() {

        let application = UIApplication.shared

        if #available(iOS 10.0, *) {

            let current = UNUserNotificationCenter.current()
            current.requestAuthorization(options: [.sound, .alert, .badge], completionHandler: {(result, error) in

                if result {
                    print("Granted")
                    application.registerForRemoteNotifications()
                }

                if let error = error {
                    print("Error: \(error)")
                }
            })
        } else {

            let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
    }
    public func completeRequestToPushNotifications(token: Data?, error: Error? = nil) {

        if let error = error {

            Log.Error(tag, "User not get permissions on send push notifications.")
            Log.Error(tag, String(describing: error))
        }

        if let token = token {

            Log.Info(tag, "Get device token for send push notifications.")
            register(deviceToken: String(data: token, encoding: .utf8)!)
        }
    }

    public func register(deviceToken token: String) {

        Log.Debug(tag, "Register device with token: \(token)")

        let keys = _keysStorage.keysFor(rights: _currentAppAccessRights)
        if nil == keys {
            return
        }

        let locale = Locale.preferredLanguages.first ?? "en"

        let task = _apiClient.Register(keys: keys!, token: token, locale: locale)
        task.async(.background, completion: { result in

            if (result.statusCode == .OK) {
                Log.Info(self.tag, "Complete success register device for push notification.")
            }

            PropertiesStorage.set(.PushDeviceToken, value: token)
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
