//
//  PushesServices.swift
//  CoreFramework
//
//  Created by Алексей on 16.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import FirebaseAuth
import FirebaseMessaging

public class PushesService: NSObject {

    public static let shared = PushesService()

    private let _tag = String.tag(PushesService.self)

    private let deviceService = DependencyResolver.get(DeviceService.self)

    public private(set) var token: String? = nil
    private let guid = Guid.new
    private let processQueue = AsyncQueue.background
    private let application = UIApplication.shared
    private let auth = Auth.auth()
    private let messaging = Messaging.messaging()

    private override init() {
        super.init()

        deviceService.subscribe(guid: guid, handler: self, tag: _tag)

        Messaging.messaging().delegate = self
    }
}

// Permissons
extension PushesService {
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

            Messaging.messaging().apnsToken = token
            Auth.auth().setAPNSToken(token, type: .unknown)
        }
    }

    public func processMessage(notification: PushSource, handler: @escaping (UIBackgroundFetchResult) -> Void) {

        Log.debug(_tag, "Recieve push notification.")

        if Auth.auth().canHandleNotification(notification) {
            handler(.noData)
            return
        }

        Messaging.messaging().appDidReceiveMessage(notification)

        print(notification)
        if let container = PushContainer.tryParse(notification) {
            PushesHandler.process(container)
        }

        handler(.newData)
    }
}
extension PushesService: MessagingDelegate {

    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {

        self.token = fcmToken
        if let device = deviceService.device {
            update(device)
        }

        Log.info(_tag, "Get FCM token: \(fcmToken)")
    }
}
extension PushesService: DeviceCacheServiceDelegate {
    public func deviceService(_ service: DeviceService, register device: Device) {
        update(device)
    }
    public func deviceService(_ service: DeviceService, update device: Device) {
        update(device)
    }
    private func update(_ device: Device) {

        guard let token = token else {
            return
        }

        if device.fcmToken == token {
            return
        }

        Log.info(_tag, "Update device fcm token.")
        
        let request = deviceService.update(device.id, token: token)
        request.async(.background, completion: { response in })
    }
}
