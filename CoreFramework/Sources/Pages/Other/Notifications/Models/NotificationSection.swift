//
//  NotificationSection.swift
//  CoreFramework
//
//  Created by Алексей on 16.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class NotificationSection {

    private static let localization = OtherNotificationController.Localization.self
    private static let keys = UserNotificationPreference.Keys.self

    public let title: OtherNotificationControllerTitle
    public private(set) var rows: [OtherNotificationControllerPreference] = []
    public var count: Int {
        return rows.count
    }
    public let table: UITableView
    public let delegate: OtherNotificationControllerDelegate

    public static func buildBookings(with title: Localizable, for preferences: UserNotificationPreference, in table: UITableView, with delegate: OtherNotificationControllerDelegate) -> NotificationSection {

        let header = OtherNotificationControllerTitle.create(with: title)
        let section = NotificationSection(with: header, in: table, with: delegate)

        section.add(for: localization.preferencesBookingsAdd, value: preferences.bookingAdd, key: keys.bookingAdd)
        section.add(for: localization.preferencesBookingsChangeStatus, value: preferences.bookingChangeStatus, key: keys.bookingChangeStatus)

        return section
    }
    public static func buildOrders(with title: Localizable, for preferences: UserNotificationPreference, in table: UITableView, with delegate: OtherNotificationControllerDelegate) -> NotificationSection {

        let header = OtherNotificationControllerTitle.create(with: title)
        let section = NotificationSection(with: header, in: table, with: delegate)

        section.add(for: localization.preferencesOrdersAdd, value: preferences.ordersAdd, key: keys.dishOrderAdd)
        section.add(for: localization.preferencesOrdersChangeStatus, value: preferences.ordersChangeStatus, key: keys.dishOrderChangeStatus)
        section.add(for: localization.preferencesOrdersPaymentComplete, value: preferences.ordersPaymentComplete, key: keys.dishOrderPaymentComplete)
        section.add(for: localization.preferencesOrdersPaymentFail, value: preferences.ordersPaymentFail, key: keys.dishOrderPaymentFail)
        section.add(for: localization.preferencesOrdersIsPrepared, value: preferences.ordersIsPrepared, key: keys.dishOrderIsPrepared)

        return section
    }
    public static func buildReviews(with title: Localizable, for preferences: UserNotificationPreference, in table: UITableView, with delegate: OtherNotificationControllerDelegate) -> NotificationSection {

        let header = OtherNotificationControllerTitle.create(with: title)
        let section = NotificationSection(with: header, in: table, with: delegate)

        section.add(for: localization.preferencesReviewsAdd, value: preferences.reviewAdd, key: keys.reviewAdd)
        section.add(for: localization.preferencesReviewsChange, value: preferences.reviewChange, key: keys.reviewChange)
        section.add(for: localization.preferencesReviewsChangeStatus, value: preferences.reviewChangeStatus, key: keys.reviewChangeStatus)

        return section
    }
    public static func buildPayments(with title: Localizable, for preferences: UserNotificationPreference, in table: UITableView, with delegate: OtherNotificationControllerDelegate) -> NotificationSection {

        let header = OtherNotificationControllerTitle.create(with: title)
        let section = NotificationSection(with: header, in: table, with: delegate)

        section.add(for: localization.preferencesPaymentsAddCard, value: preferences.paymentCardAdd, key: keys.paymentCardAdd)

        return section
    }

    fileprivate init(with title: OtherNotificationControllerTitle, in table: UITableView, with delegate: OtherNotificationControllerDelegate) {
        self.title = title
        self.table = table
        self.delegate = delegate
    }
    private func add(for title: Localizable, value: Bool, key: String) {

        let cell = table.dequeueReusableCell(withIdentifier: OtherNotificationControllerPreference.identifier) as! OtherNotificationControllerPreference
        cell.setup(title: title, value: value, key: key)
        cell.delegate = delegate

        rows.append(cell)
    }

    subscript(index: Int) -> UITableViewCell {
        return rows[index]
    }
}
