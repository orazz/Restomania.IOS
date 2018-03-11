//
//  PushesServices.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 16.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
//import FirebaseAuth
//import FirebaseMessaging

public typealias PushNotification = [AnyHashable : Any]
public class NotificationsServices: NSObject {

    public static let shared = NotificationsServices()

    private let _tag = String.tag(NotificationsServices.self)

    private let devicesApi = DependencyResolver.resolve(NotificationsDevicesApiService.self)
    private let keyService = DependencyResolver.resolve(ApiKeyService.self)
    private let lightStorage = DependencyResolver.resolve(LightStorage.self)

    private let application = UIApplication.shared
//    private let auth = Auth.auth()
//    private let messaging = Messaging.messaging()
    private let processQueue = AsyncQueue.background
    private let guid = Guid.new

    private override init() {
        super.init()

        keyService.subscribe(guid: guid, handler: self, tag: _tag)
    }
}

// Permissons
extension NotificationsServices {
    public func needRequest() -> Bool {
        return !UIApplication.shared.isRegisteredForRemoteNotifications
    }
    public var allowRemoteNotifications: Bool {
        return UIApplication.shared.isRegisteredForRemoteNotifications
    }
    public func requestRemoteNotificattions() {
        application.registerForRemoteNotifications()
    }
    public func requestLocalNotifications() {

        let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
        application.registerUserNotificationSettings(settings)
    }
    public func registerForRemoteNotifications(token: Data?, error: Error? = nil) {

        if let error = error {

            Log.error(_tag, "User not get permissions on send push notifications.")
            Log.error(_tag, String(describing: error))
            return
        }

        if let token = token {

            Log.info(_tag, "Get device token for send push notifications.")

//            Messaging.messaging().delegate = self
//            Messaging.messaging().apnsToken = token
//            Auth.auth().setAPNSToken(token, type: .unknown)
        }
    }

    public func processMessage(notification: PushNotification, handler: @escaping (UIBackgroundFetchResult) -> Void) {

        Log.debug(_tag, "Recieve push notification.")
        print(notification)

//        if Auth.auth().canHandleNotification(notification) {
//            handler(.noData)
//            return
//        }

//        Messaging.messaging().appDidReceiveMessage(notification)
        handler(.newData)
    }
}
//extension NotificationsServices: MessagingDelegate {
//
//    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        print(fcmToken)
//    }
//}
extension NotificationsServices: ApiKeyServiceDelegate {
    public func apiKeyService(_ service: ApiKeyService, update keys: ApiKeys, for role: ApiRole) {

//        guard let token = token else {
//            return
//        }
    }
}

