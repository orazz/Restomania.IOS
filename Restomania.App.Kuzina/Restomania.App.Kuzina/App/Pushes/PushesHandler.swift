//
//  PushesHandler.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 16.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import AsyncTask
import IOSLibrary
import UIKit
import NotificationBannerSwift
import Gloss

public class PushesHandler {

    private static let tag = String.tag(PushesHandler.self)

    public static func process(_ push: NotificationContainer) {

        let completer: Action<NotificationBanner?> = { banner in
            if let banner = banner,
                push.allowNotify {

                DispatchQueue.main.async {
                    banner.show()
                }
            }
        }

        switch push.event {
            case .DishOrderAddedForPlace,
                 .DishOrderAddedForUser,
                 .DishOrderChangedStatusForPlace,
                 .DishOrderChangedStatusForUser,
                 .DishOrderPaymentFailForPlace,
                 .DishOrderPaymentFailForUser,
                 .DishOrderPaymentCompleteForPlace,
                 .DishOrderPaymentCompleteForUser,
                 .DishOrderIsPreparedForUser:
                 processDishOrder(push, complete: completer)
            default:
                return
        }
    }
    private static func processDishOrder(_ push: NotificationContainer, complete: @escaping Action<NotificationBanner?>) {

        guard let model = DishOrderModel(json: push.model) else {
            return
        }

        let title = "\(push.message).Title".localized
        let subtitle = String(format: push.message.localized, arguments: push.messageArgs)
        let banner = NotificationBanner(title: title, subtitle: subtitle)
        ThemeSettings.Elements.applyStyles(to: banner)
        banner.onTap = {
            DispatchQueue.main.async {

                if let delegate = UIApplication.shared.delegate as? AppDelegate,
                    let root = delegate.window?.rootViewController as? UINavigationController,
                    let navigator = root.presentedViewController as? UINavigationController {

                    let vc = OneOrderController(for: model.id)
                    navigator.pushViewController(vc, animated: true)
                }
            }
        }

        let request = CacheServices.orders.find(model.id)
        request.async(AsyncQueue.background, completion: { _ in complete(banner)})
    }
    private class DishOrderModel: JSONDecodable {

        private struct Keys {
            public static let id = "ID"
            public static let status = "Status"
        }

        public let id: Long
        public let status: DishOrderStatus

        public required init?(json: JSON) {
            id = (Keys.id <~~ json)!
            status = (Keys.status <~~ json)!
        }
    }
}
