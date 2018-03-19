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
    private var rows: [NotificationSection] = []
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return themeColors.statusBarOnNavigation
    }

    //Services
    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let accountApiService = DependencyResolver.get(UserAccountApiService.self)
    private let changeApiService = DependencyResolver.get(UserChangeApiService.self)
    private let deviceService = DependencyResolver.get(DeviceService.self)

    //Data
    private let _tag = String.tag(OtherNotificationController.self)
    private let loadQueue: AsyncQueue

    public var showBookingsPreferences: Bool = false
    public var showOrdersPreferences: Bool = true
    public var showReviewsPreferences: Bool = false
    public var showPaymentsPreferences: Bool = true


    public init() {
        loadQueue = AsyncQueue.createForControllerLoad(for: _tag)

        super.init(style: .grouped)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: Life circle
    public override func loadView() {
        super.loadView()

        view.backgroundColor = themeColors.divider

        tableView.backgroundColor = themeColors.divider
        tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.sectionFooterHeight = 0
        tableView.estimatedRowHeight = 80
        tableView.estimatedSectionHeaderHeight = 45
        tableView.estimatedSectionFooterHeight = 0
        OtherNotificationControllerPreference.register(in: tableView)

        loader = InterfaceLoader(for: tableView)

        refreshControl = tableView.addRefreshControl(for: self, action: #selector(needReload))
        refreshControl?.backgroundColor = themeColors.divider
        refreshControl?.tintColor = themeColors.dividerText
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
    private func buildRows(for preferences: UserNotificationPreference) -> [NotificationSection] {

        var result = [NotificationSection]()

        if (showBookingsPreferences) {
            let section = NotificationSection.buildBookings(with: Localization.titleBookings, for: preferences, in: tableView, with: self)
            result.append(section)
        }

        if (showOrdersPreferences) {
            let section = NotificationSection.buildOrders(with: Localization.titleOrders, for: preferences, in: tableView, with: self)
            result.append(section)
        }

        if (showReviewsPreferences) {
            let section = NotificationSection.buildReviews(with: Localization.titleReviews, for: preferences, in: tableView, with: self)
            result.append(section)
        }

        if (showPaymentsPreferences) {
            let section = NotificationSection.buildPayments(with: Localization.titlePayments, for: preferences, in: tableView, with: self)
            result.append(section)
        }

        return result
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
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return rows.count
    }
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return rows[section].title
    }
    public override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows[section].rows.count
    }
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return rows[indexPath.section][indexPath.row]
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
