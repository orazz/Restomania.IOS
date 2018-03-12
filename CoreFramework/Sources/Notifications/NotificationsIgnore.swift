//
//  NotificationsIgnore.swift
//  Notifications
//
//  Created by Алексей on 22.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

open class NotificationsIgnore {

    private static var pushes: [String] = []

    public static func allow(_ id: String) -> Bool {
        return pushes.notAny({ $0 == id })
    }
    public static func isIgnored(_ id: String) -> Bool {
        return pushes.any({ $0 == id })
    }

    public static func ignore(_ push: PushContainer) {
        ignore(push.id)
    }
    public static func ignore(_ id: String) {
        pushes.append(id)
    }

    open class Orders {

        private static var ignored: [OrderPushModel] = []

        public static func isIgnored(_ id: Long, with status: DishOrderStatus) -> Bool {
            return ignored.any({ $0.id == id && $0.status == status })
        }

        public static func add(_ orderId: Long) {
            ignored.append(OrderPushModel(orderId, with: .processing))
        }
        public static func cancel(_ orderId: Long) {
            ignored.append(OrderPushModel(orderId, with: .canceledByUser))
        }
    }
}
