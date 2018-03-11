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
import CoreTools
import CoreDomains
import CoreStorageServices
import UITools
import UIElements

public class PushesHandler {

    private static let tag = String.tag(PushesHandler.self)

    public static func process(_ push: NotificationContainer) {

        let completer: Action<BannerAlert?> = { banner in
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
    private static func processDishOrder(_ push: NotificationContainer, complete: @escaping Action<BannerAlert?>) {

        guard let model = DishOrderModel(json: push.model) else {
            return
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
