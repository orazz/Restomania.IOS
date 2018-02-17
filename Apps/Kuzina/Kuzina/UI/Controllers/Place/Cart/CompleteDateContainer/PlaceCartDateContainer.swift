//
//  PlaceCartCompleteDateContainer.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import CoreStorageServices

public class PlaceCartDateContainer: UITableViewCell {

    fileprivate enum TimePickerComponents: Int {
        case hours = 0
        case minutes = 1
    }
    fileprivate enum DaySelectorSegments: Int {
        case now = 0
        case today = 1
        case tommorow = 2
    }

    private static let nibName = "\(String.tag(PlaceCartDateContainer.self))View"
    public static func create(for delegate: PlaceCartDelegate) -> PlaceCartDateContainer {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let cell = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceCartDateContainer

        cell.timeFormatter = DateFormatter(for: "HH:mm")
        cell.dateFormatter = DateFormatter(for: "dd.MM")
        let utcTimeZone = TimeZone.utc
        cell.timeFormatter.timeZone = utcTimeZone
        cell.dateFormatter.timeZone = utcTimeZone

        cell.delegate = delegate
        cell.refresh()

        return cell
    }

    //UI elements
    @IBOutlet private weak var scheduleView: ScheduleDisplay!
    @IBOutlet private weak var dateChecker: UISegmentedControl!
    @IBOutlet private weak var timePicker: UIPickerView!
    @IBOutlet private weak var dateTimeLabel: UILabel!

    //Data
    private var timeFormatter: DateFormatter!
    private var dateFormatter: DateFormatter!
    private var delegate: PlaceCartDelegate!

    private var container: PlaceCartController.CartContainer {
        return delegate.takeCartContainer()
    }
    private var cart: CartService {
        return delegate.takeCart()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        dateChecker.tintColor = ThemeSettings.Colors.main
        dateChecker.backgroundColor = ThemeSettings.Colors.additional
        dateChecker.addTarget(self, action: #selector(handleDaySelect), for: .valueChanged)

        dateChecker.removeAllSegments()
        dateChecker.insertSegment(withTitle: PlaceCartController.Localization.Buttons.now.localized, at: DaySelectorSegments.now.rawValue, animated: true)
        dateChecker.insertSegment(withTitle: PlaceCartController.Localization.Buttons.today.localized, at: DaySelectorSegments.today.rawValue, animated: true)
        dateChecker.insertSegment(withTitle: PlaceCartController.Localization.Buttons.tomorrow.localized, at: DaySelectorSegments.tommorow.rawValue, animated: true)

        timePicker.dataSource = self
        timePicker.delegate = self

        dateTimeLabel.font = ThemeSettings.Fonts.default(size: .head)
        dateTimeLabel.textColor = ThemeSettings.Colors.main
    }

    private func refresh() {

        refreshSchedule()

        let now = Calendar.current.date(byAdding: .minute, value: 15, to: nowLikeUTC)!
        let completeAt = cart.buildCompleteAt()
        if (completeAt < now) {
            dateChecker.select(day: .now)
            handleDaySelect()
        } else {
            setup(dateAndTime: completeAt)
        }
    }
    private var nowLikeUTC: Date {

        let now = Date()

        let calendar = Calendar.utcCurrent

        var components = DateComponents()
        components.year = calendar.component(.year, from: now)
        components.month = calendar.component(.month, from: now)
        components.day = calendar.component(.day, from: now)
        components.hour = now.hours()
        components.minute = now.minutes()
        components.second = 0

        return calendar.date(from: components)!
    }
    private func refreshSchedule() {

        if let summary = delegate.takeSummary() {
            scheduleView.update(by: summary.Schedule)
        }
    }
    private func updateTimeAndRefreshTimePicker(hours: Int, minutes: Int) {

        var wrapedHours = hours
        var wrapedMinutes = (minutes / 5) * 5
        if (minutes % 5 != 0) {
            wrapedMinutes += 5
        }

        if (wrapedMinutes > 59) {
            wrapedHours += 1
            wrapedMinutes = wrapedMinutes % 60
        }

        timePicker.set(wrapedHours % 24, to: .hours)
        timePicker.set(wrapedMinutes / 5, to: .minutes)

        update(hours: wrapedHours, minutes: wrapedMinutes)
    }
    private func refreshDateTimeLabel() {

        let time = cart.time
        let date = cart.date

        let format = PlaceCartController.Localization.Labels.orderOn.localized
        dateTimeLabel.text = String(format: format, timeFormatter.string(from: time), dateFormatter.string(from: date))
    }

}
extension PlaceCartDateContainer {

    private func setup(dateAndTime date: Date) {

        //Time
        updateTimeAndRefreshTimePicker(hours: date.utcHours(), minutes: date.utcMinutes())

        //Date
        let side = Calendar.utcCurrent.date(bySettingHour: 23, minute: 59, second: 0, of: Date())!
        if (date < side) {
            dateChecker.select(day: .today)
        } else {
            dateChecker.select(day: .tommorow)
        }
        handleDaySelect()
    }

    private func update(date: Date) {

        cart.date = date

        scheduleView.focus(on: date.utcDayOfWeek())
        refreshDateTimeLabel()
    }
    private func update(hours: Int, minutes: Int) {
        cart.time = timeFormatter.date(from: "\(String(format: "%02d", hours % 24)):\(String(format: "%02d", minutes % 60))")!

        refreshDateTimeLabel()
    }
}
// MARK: Segment
extension PlaceCartDateContainer {
    @objc private func handleDaySelect() {

        let segment = DaySelectorSegments(rawValue: dateChecker.selectedSegmentIndex)!
        switch segment {
            case .now,
                 .today:
                update(date: Date().noon)
            case .tommorow:
                update(date: Date().tomorrow)
        }

        if (segment == .now) {
            timePicker.isHidden = true

            let now = Calendar.current.date(byAdding: .minute, value: 10, to: nowLikeUTC)!
            updateTimeAndRefreshTimePicker(hours: now.utcHours(), minutes: now.utcMinutes())
        } else {
            timePicker.isHidden = false
        }

    }
}

extension PlaceCartDateContainer: UIPickerViewDelegate, UIPickerViewDataSource {
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        switch TimePickerComponents(rawValue: component)! {
            case .hours:
                update(hours: row, minutes: cart.time.utcMinutes())
            case .minutes:
                update(hours: cart.time.utcHours(), minutes: row * 5)
        }
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        switch TimePickerComponents(rawValue: component)! {
            case .hours:
                return String(format: "%02d", row)
            case .minutes:
                return String(format: "%02d", row * 5)
        }
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        switch TimePickerComponents(rawValue: component)! {
            case .hours:
                return 24
            case .minutes:
                return 60 / 5
        }
    }
}

extension UISegmentedControl {
    fileprivate func select(day: PlaceCartDateContainer.DaySelectorSegments) {
        self.selectedSegmentIndex = day.rawValue
    }
}
extension UIPickerView {
    fileprivate func set(_ value: Int, to part: PlaceCartDateContainer.TimePickerComponents) {
        self.selectRow(value, inComponent: part.rawValue, animated: true)
    }
}

extension PlaceCartDateContainer: PlaceCartContainerCell {
    public func viewDidAppear() {}
    public func viewDidDisappear() {}
    public func updateData(with: PlaceCartDelegate) {
        refreshSchedule()
    }
}
extension PlaceCartDateContainer: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        return 245
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
