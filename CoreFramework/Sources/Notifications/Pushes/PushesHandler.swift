//
//  PushesHandler.swift
//  CoreFramework
//
//  Created by Алексей on 16.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import UIKit
import Gloss
import AVFoundation

public class PushesHandler {

    private static let tag = String.tag(PushesHandler.self)
    private static let router = DependencyResolver.get(Router.self)
    private static let ordersService = DependencyResolver.get(OrdersCacheService.self)

    public static func process(_ push: PushContainer) {

        let container = PushesHandler.build(push)
        process(container)
    }
    public static func process(_ notification: NotificationContainer?) {

        guard let notification = notification else {
            return
        }

        if let banner = notification.banner {
            banner.onTap = {

                if let controller = notification.controller,
                    let navigator = router.navigator {

                    navigator.pushViewController(controller, animated: true)
                }
            }

            DispatchQueue.main.async {
                banner.show()

                if let _ = notification.sound,
                    !notification.silent {

                    let defaultSound: SystemSoundID = 1016
                    AudioServicesPlaySystemSound(defaultSound)
                }
            }
        }
    }
    public static func build(_ push: PushContainer, force: Bool = false) -> NotificationContainer? {

        if (!force && NotificationsIgnore.isIgnored(push.id)) {
            return nil
        }

        switch push.event {
        case .dishOrderAddedForUser,
             .dishOrderChangedStatusForUser,
             .dishOrderPaymentFailForUser,
             .dishOrderPaymentCompleteForUser,
             .dishOrderIsPreparedForUser:
            return processDishOrder(push, force)
        default:
            return nil
        }
    }
    private static func processDishOrder(_ push: PushContainer, _ force: Bool) -> NotificationContainer? {

        guard let data = push.data,
                let model = OrderPushModel(json: data) else {
            return nil
        }

        if (!force && NotificationsIgnore.Orders.isIgnored(model.id, with: model.status)) {
            return nil
        }

        let request = ordersService.find(model.id)
        request.async(.background, completion: { _ in })

        if (push.silent) {
            return nil
        }


        let container = NotificationContainer(from: push)
        container.controller = OneOrderController(for: model.id, needRequest: true)

        let title = "\(push.message).Title".localized
        let subtitle = String(format: push.message.localized, arguments: push.messageArgs)
        container.banner = BannerAlert(title: title, subtitle: subtitle)

        return container
    }
}
