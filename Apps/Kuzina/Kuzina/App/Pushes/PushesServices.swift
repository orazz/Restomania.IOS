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
import CoreTools
import CoreApiServices
import BaseApp

public class PushesService {

    public static let shared = PushesService()

    private let tag = String.tag(PushesService.self)
    private var token: String?
    private let processQueue: AsyncQueue
    private let devicesApi = DependencyResolver.resolve(NotificationsDevicesApiService.self)
    private let apiKeysService = DependencyResolver.resolve(ApiKeyService.self)
    private let lightStorage = DependencyResolver.resolve(LightStorage.self)

    private init() {

        processQueue = AsyncQueue.background
    }
    public func processMessage(push: [AnyHashable: Any]) {

        Log.debug(tag, "Recieve push notification.")
        guard let container = NotificationContainer.tryParse(push) else {
            return
        }

        let task = Task<Void> { _ in

            PushesHandler.process(container)

            Log.info(self.tag, "Notification is successful parse and process.")
        }
        task.async(processQueue)

        Log.debug(self.tag, "Complete process push-notification.")
    }

    // MARK: Rquest permissions
    public func requestPermissions() {

        let application = UIApplication.shared

        let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
    }
    public func completeRequestToPushNotifications(token: Data?, error: Error? = nil) {

        if let error = error {

            Log.error(tag, "User not get permissions on send push notifications.")
            Log.error(tag, String(describing: error))
        }

        if let token = token {

            Log.info(tag, "Get device token for send push notifications.")

            let parsed = token.map ({ String(format: "%02.2hhx", $0) }).joined()
            register(parsed)
        }
    }

    // MARK: Remote access
    public func register(_ token: String) {

        Log.debug(tag, "Register device with token: \(token)")

        if (!apiKeysService.isAuth) {
            return
        }

        let locale = Locale.preferredLanguages.first ?? "en"

        if (self.token == token) {
            return
        }

        self.token = token

        let task = devicesApi.Register(token: token, locale: locale)
        task.async(processQueue, completion: { result in

            if (result.statusCode == .OK) {
                Log.info(self.tag, "Complete success register device for push notification.")
            }

            self.lightStorage.set(.devicePushToken, value: token)
        })
    }
}
