//
//  PlaceCartCompleteDateContainer.swift
//  CoreFramework
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class PlaceCartDateContainer: UIView {

    fileprivate enum TimePickerComponents: Int {
        case hours = 0
        case minutes = 1
    }
    fileprivate enum DaySelectorSegments: Int {
        case now = 0
        case today = 1
        case tommorow = 2
    }

    //UI elements
    @IBOutlet private weak var content: UIView!
    @IBOutlet private weak var scheduleView: ScheduleDisplay!
    @IBOutlet private weak var dateChecker: UISegmentedControl!
    @IBOutlet private weak var timePicker: UIPickerView!
    @IBOutlet private weak var dateTimeLabel: UILabel!
    @IBOutlet private weak var pickerHeightConstraint: NSLayoutConstraint!
    private var heightConstraint: NSLayoutConstraint?
    private let defaultElementHeight: CGFloat = 250.0
    private let defaultPickerHeight: CGFloat = 120.0

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    //Data
    private var delegate: PlaceCartDelegate?
    private var timeFormatter: DateFormatter!
    private var dateFormatter: DateFormatter!
    private var loadElement: Bool = false

    private var container: PlaceCartController.CartContainer? {
        return delegate?.takeCartContainer()
    }
    private var cart: CartService? {
        return delegate?.takeCart()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initialize()
    }
    private func initialize() {

        let utcTimeZone = TimeZone.utc
        self.timeFormatter = DateFormatter(for: "HH:mm")
        self.timeFormatter.timeZone = utcTimeZone

        self.dateFormatter = DateFormatter(for: "dd.MM")
        self.dateFormatter.timeZone = utcTimeZone

        connect()
        loadViews()

        refresh()
    }
    private func connect() {

        let nibName = String.tag(PlaceCartDateContainer.self)
        Bundle.coreFramework.loadNibNamed(nibName, owner: self, options: nil)
        self.addSubview(content)
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        heightConstraint = self.constraints.find({ $0.firstAttribute == .height })
    }
    public func loadViews() {

        dateChecker.tintColor = themeColors.actionMain
        dateChecker.backgroundColor = themeColors.actionContent
        dateChecker.addTarget(self, action: #selector(handleDaySelect), for: .valueChanged)

        dateChecker.removeAllSegments()
        dateChecker.insertSegment(withTitle: PlaceCartController.Localization.Buttons.now.localized, at: DaySelectorSegments.now.rawValue, animated: true)
        dateChecker.insertSegment(withTitle: PlaceCartController.Localization.Buttons.today.localized, at: DaySelectorSegments.today.rawValue, animated: true)
        dateChecker.insertSegment(withTitle: PlaceCartController.Localization.Buttons.tomorrow.localized, at: DaySelectorSegments.tommorow.rawValue, animated: true)

        timePicker.dataSource = self
        timePicker.delegate = self

        dateTimeLabel.font = themeFonts.default(size: .head)
        dateTimeLabel.textColor = themeColors.contentText

        backgroundColor = themeColors.contentBackground
    }

    private func refresh() {
        guard let cart = cart else {
            return
        }

        refreshSchedule()

        let now = Calendar.current.date(byAdding: .minute, value: 15, to: nowLikeUTC)!
        let completeAt = cart.buildCompleteAt()
        if (completeAt < now) {
            dateChecker.select(day: .now)
            handleDaySelect()
        } else {
            setup(dateAndTime: completeAt)
        }

        loadElement = true
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

        if let summary = delegate?.takeSummary() {
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
        guard let cart = self.cart else {
            return
        }

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
        guard let cart = self.cart else {
            return
        }

        cart.date = date

        scheduleView.focus(on: date.utcDayOfWeek())
        refreshDateTimeLabel()
    }
    private func update(hours: Int, minutes: Int) {
        guard let cart = self.cart else {
            return
        }

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
            let now = Calendar.current.date(byAdding: .minute, value: 10, to: nowLikeUTC)!
            updateTimeAndRefreshTimePicker(hours: now.utcHours(), minutes: now.utcMinutes())

            hidePicker()
        } else {
            showPicker()
        }
    }
    private func hidePicker() {

        if (timePicker.isHidden && loadElement) {
            return
        }

        timePicker.isHidden = true
        resize(pickerHeight: 0)
    }
    private func showPicker() {

        if (!timePicker.isHidden && loadElement) {
            return
        }

        timePicker.isHidden = false
        resize(pickerHeight: defaultPickerHeight)
    }
    private func resize(pickerHeight: CGFloat) {

        self.pickerHeightConstraint.constant = pickerHeight
        if (pickerHeight == 0.0) {
            self.heightConstraint?.constant = (defaultElementHeight - defaultPickerHeight)
        }
        else {
            self.heightConstraint?.constant = defaultElementHeight
        }

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
            self.timePicker.layoutIfNeeded()
            self.dateTimeLabel.layoutIfNeeded()
        }

        delegate?.resize()
    }
}

extension PlaceCartDateContainer: UIPickerViewDelegate, UIPickerViewDataSource {
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let cart = self.cart else {
            return
        }

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

extension PlaceCartDateContainer: PlaceCartElement {
    public func update(with delegate: PlaceCartDelegate) {

        self.delegate = delegate
        refresh()
    }
    public func height() -> CGFloat {
        return heightConstraint?.constant ?? defaultElementHeight
    }
}

