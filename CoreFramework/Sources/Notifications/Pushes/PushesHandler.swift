//
//  PushesHandler.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 16.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import UIKit
import Gloss

public class PushesHandler {

    private static let tag = String.tag(PushesHandler.self)
    private static let router = DependencyResolver.resolve(Router.self)

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

                if let ctor = notification.controller,
                    let vc = ctor(),
                    let navigator = router.navigator {

                    navigator.pushViewController(vc, animated: true)
                }
            }

            banner.show()
        }
    }
    public static func build(_ push: PushContainer, force: Bool = false ) -> NotificationContainer? {

        if (NotificationsIgnore.isIgnored(push.id) || !force) {
            return nil
        }

        let completer: Action<BannerAlert?> = { banner in
            if let banner = banner,
                push.allowNotify {

                DispatchQueue.main.async {
                    banner.show()
                }
            }
        }

        switch push.event {
        case .dishOrderAddedForUser,
             .dishOrderChangedStatusForUser,
             .dishOrderPaymentFailForUser,
             .dishOrderPaymentCompleteForUser,
             .dishOrderIsPreparedForUser:
            return processDishOrder(push, complete: completer)
        default:
            return nil
        }
    }
    private static func processDishOrder(_ push: PushContainer, complete: @escaping Action<BannerAlert?>) -> NotificationContainer? {

        guard let data = push.data,
                let model = OrderPushModel(json: data) else {
            return nil
        }

        if (NotificationsIgnore.Orders.isIgnored(model.id, with: model.status)) {
            return nil
        }

        let title = "\(push.message).Title".localized
        let subtitle = String(format: push.message.localized, arguments: push.messageArgs)
        let banner = BannerAlert(title: title, subtitle: subtitle)
        banner.onTap = {
//            let router = DependencyResolver.resolve(Router.self)
//            router.goToOrder(orderId: model.id, reset: false)
        }

        let orders = DependencyResolver.resolve(OrdersCacheService.self)
        let request = orders.find(model.id)
        request.async(.background, completion: { _ in complete(banner)})

        return nil
    }
}
