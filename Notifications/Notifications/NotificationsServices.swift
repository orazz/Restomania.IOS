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

public class NotificationsServices {

    public static let shared = NotificationsServices()

    private let tag = String.tag(PushesService.self)
    private let guid = Guid.new
    private var token: String?
    private let processQueue: AsyncQueue

    private let devicesApi = DependencyResolver.resolve(NotificationsDevicesApiService.self)
    private let keyService = DependencyResolver.resolve(ApiKeyService.self)
    private let lightStorage = DependencyResolver.resolve(LightStorage.self)

    private init() {

        token = lightStorage.get(.devicePushToken)
        processQueue = AsyncQueue.background

        keyService.subscribe(guid: guid, handler: self, tag: tag)
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

    public func saveAndRegister(_ token: String) {

        Log.debug(tag, "Register device with token: \(token)")
        self.token = token

        if (!keyService.isAuth) {
            return
        }
        if (lightStorage.get(.devicePushToken) == token) {
            return
        }

        let locale = Locale.preferredLanguages.first ?? "en"
        let task = devicesApi.Register(token: token, locale: locale)
        task.async(processQueue, completion: { result in

            if (result.isSuccess) {
                Log.info(self.tag, "Complete success register device for push notification.")
            }

            self.lightStorage.set(.devicePushToken, value: token)
        })
    }
    public func clear() {
        lightStorage.remove(.devicePushToken)
    }
}

// Permissons
extension NotificationsServices {
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
            saveAndRegister(parsed)
        }
    }
}

extension NotificationsServices: ApiKeyServiceDelegate {
    public func apiKeyService(_ service: ApiKeyService, update keys: ApiKeys, for role: ApiRole) {

        guard let token = token else {
            return
        }

        saveAndRegister(token)
    }
}
