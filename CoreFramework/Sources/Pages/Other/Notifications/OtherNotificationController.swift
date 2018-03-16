//
//  OtherNotificationController.swift
//  CoreFramework
//
//  Created by Алексей on 11.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public protocol OtherNotificationControllerDelegate {
    func change(key: String, on value: Bool) -> RequestResult<Bool>
}
public class OtherNotificationController: UITableViewController {

    //UI
    private var loader: InterfaceLoader!
    private var rows: [UITableViewCell] = []
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return themeColors.statusBarOnNavigation
    }

    //Services
    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let accountApiService = DependencyResolver.resolve(UserAccountApiService.self)
    private let changeApiService = DependencyResolver.resolve(UserChangeApiService.self)
    private let deviceService = DependencyResolver.resolve(DeviceService.self)

    //Data
    private let _tag = String.tag(OtherNotificationController.self)
    private let loadQueue: AsyncQueue

    public var showBookingsPreferences: Bool = false
    public var showOrdersPreferences: Bool = true
    public var showReviewsPreferences: Bool = false
    public var showPaymentsPreferences: Bool = true


    public init() {
        loadQueue = AsyncQueue.createForControllerLoad(for: _tag)

        super.init(style: .plain)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: Life circle
    public override func loadView() {
        super.loadView()

        view.backgroundColor = themeColors.contentDivider

        tableView.backgroundColor = themeColors.contentDivider
        tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        OtherNotificationControllerTitle.register(in: tableView)
        OtherNotificationControllerPreference.register(in: tableView)

        loader = InterfaceLoader(for: tableView)

        refreshControl = tableView.addRefreshControl(for: self, action: #selector(needReload))
        refreshControl?.backgroundColor = themeColors.contentDivider
        refreshControl?.tintColor = themeColors.contentDividerText

        apply(update: UserNotificationPreference())
    }
    public override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = Localization.title.localized

        if (rows.isFilled) {
            needReload()
        }
    }


    private func loadData() {

        loader.show()

        requestNotifications()
    }
    @objc private func needReload() {
        requestNotifications()
    }
    private func requestNotifications() {

        guard let device = deviceService.device else {
            apply(update: nil)
            return
        }

        let request = accountApiService.preferences(deviceId: device.id)
        request.async(loadQueue, completion: { response in

            if (response.isFail) {
                DispatchQueue.main.async {
                    self.alert(about: response)
                }
            }

            self.apply(update: response.data)
        })
    }
    private func apply(update: UserNotificationPreference?) {


        DispatchQueue.main.async {
            if let preferences = update  {
                self.rows = self.buildRows(for: preferences)
            }
            self.tableView.reloadData()

            self.loader.hide()
            self.refreshControl?.endRefreshing()
        }
    }
}
extension OtherNotificationController {
    private func buildRows(for preferences: UserNotificationPreference) -> [UITableViewCell] {

        var result = [UITableViewCell]()

        let keys = UserNotificationPreference.Keys.self

        if (showBookingsPreferences) {
            result.append(buildTitleRow(for: Localization.titleBookings))
            result.append(buildPreferenceRow(for: Localization.preferencesBookingsAdd, value: preferences.bookingAdd, key: keys.bookingAdd))
            result.append(buildPreferenceRow(for: Localization.preferencesBookingsChangeStatus, value: preferences.bookingChangeStatus, key: keys.bookingChangeStatus))
        }

        if (showOrdersPreferences) {
            result.append(buildTitleRow(for: Localization.titleOrders))
            result.append(buildPreferenceRow(for: Localization.preferencesOrdersAdd, value: preferences.ordersAdd, key: keys.dishOrderAdd))
            result.append(buildPreferenceRow(for: Localization.preferencesOrdersChangeStatus, value: preferences.ordersChangeStatus, key: keys.dishOrderChangeStatus))
            result.append(buildPreferenceRow(for: Localization.preferencesOrdersPaymentComplete, value: preferences.ordersPaymentComplete, key: keys.dishOrderPaymentComplete))
            result.append(buildPreferenceRow(for: Localization.preferencesOrdersPaymentFail, value: preferences.ordersPaymentFail, key: keys.dishOrderPaymentFail))
            result.append(buildPreferenceRow(for: Localization.preferencesOrdersIsPrepared, value: preferences.ordersIsPrepared, key: keys.dishOrderIsPrepared))
        }

        if (showReviewsPreferences) {
            result.append(buildTitleRow(for: Localization.titleReviews))
            result.append(buildPreferenceRow(for: Localization.preferencesReviewsAdd, value: preferences.reviewAdd, key: keys.reviewAdd))
            result.append(buildPreferenceRow(for: Localization.preferencesReviewsChange, value: preferences.reviewChange, key: keys.reviewChange))
            result.append(buildPreferenceRow(for: Localization.preferencesReviewsChangeStatus, value: preferences.reviewChangeStatus, key: keys.reviewChangeStatus))
        }

        if (showPaymentsPreferences) {
            result.append(buildTitleRow(for: Localization.titlePayments))
            result.append(buildPreferenceRow(for: Localization.preferencesPaymentsAddCard, value: preferences.paymentCardAdd, key: keys.paymentCardAdd))
        }

        return result
    }
    private func buildTitleRow(for title: Localizable) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OtherNotificationControllerTitle.identifier) as! OtherNotificationControllerTitle
        cell.setup(title: title)

        return cell
    }
    private func buildPreferenceRow(for title: Localizable, value: Bool, key: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OtherNotificationControllerPreference.identifier) as! OtherNotificationControllerPreference
        cell.setup(title: title, value: value, key: key, delegate: self)

        return cell
    }
}
extension OtherNotificationController: OtherNotificationControllerDelegate {
    public func change(key: String, on value: Bool) -> Task<ApiResponse<Bool>> {
        return RequestResult<Bool> { handler in

            guard let device = self.deviceService.device else {
                handler(ApiResponse(statusCode: .BadRequest, response: nil))
                return
            }

            let update = PartialUpdateContainer(property: key, update: value)
            let request = self.changeApiService.preferences(deviceId: device.id, updates: [update])
            request.async(self.loadQueue, completion: { response in

                if (response.isFail) {
                    DispatchQueue.main.async {
                        self.alert(about: response)
                    }
                }

                handler(response)
            })
        }
    }
}
extension OtherNotificationController {
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return rows[indexPath.row]
    }
}
extension OtherNotificationController {
    public enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(OtherNotificationController.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        case title = "Title"

        case titleBookings = "Title.Bookings"
        case titleOrders = "Title.Orders"
        case titleReviews = "Title.Reviews"
        case titlePayments = "Title.Payments"

        case preferencesBookingsAdd = "Preferences.Bookings.Add"
        case preferencesBookingsChangeStatus = "Preferences.Bookings.ChangeStatus"

        case preferencesOrdersAdd = "Preferences.Orders.Add"
        case preferencesOrdersChangeStatus = "Preferences.Orders.ChangeStatus"
        case preferencesOrdersPaymentComplete = "Preferences.Orders.PaymentComplete"
        case preferencesOrdersPaymentFail = "Preferences.Orders.PaymentFail"
        case preferencesOrdersIsPrepared = "Preferences.Orders.IsPrepared"

        case preferencesReviewsAdd = "Preferences.Reviews.Add"
        case preferencesReviewsChange = "Preferences.Reviews.Change"
        case preferencesReviewsChangeStatus = "Preferences.Reviews.ChangeStatus"

        case preferencesPaymentsAddCard = "Preferences.Payments.AddCard"
    }
}
