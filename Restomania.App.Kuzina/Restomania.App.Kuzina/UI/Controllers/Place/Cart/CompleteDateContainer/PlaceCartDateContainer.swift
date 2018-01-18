//
//  PlaceCartCompleteDateContainer.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class PlaceCartDateContainer: UITableViewCell {

    private static let nibName = "PlaceCartDateContainerView"
    public static func create(for delegate: PlaceCartDelegate) -> PlaceCartDateContainer {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let cell = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceCartDateContainer

        cell.delegate = delegate
        cell.setupMarkup()
        cell.refresh()

        return cell
    }

    //UI elements
    @IBOutlet private weak var scheduleView: ScheduleDisplay!
    @IBOutlet private weak var dateChecker: UISegmentedControl!
    @IBOutlet private weak var timePicker: UIPickerView!
    @IBOutlet private weak var dateTimeLabel: UILabel!
    private func setupMarkup() {

        dateChecker.tintColor = ThemeSettings.Colors.main
        dateChecker.backgroundColor = ThemeSettings.Colors.additional
        dateChecker.addTarget(self, action: #selector(changeDate), for: .valueChanged)

        timePicker.dataSource = self
        timePicker.delegate = self

        dateTimeLabel.font = ThemeSettings.Fonts.default(size: .head)
        dateTimeLabel.textColor = ThemeSettings.Colors.main

        timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"

        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
    }
    private func updateDateTimeLabel() {

        let time = cart.time
        let date = cart.date

        dateTimeLabel.text = "Заказ на \(timeFormatter.string(from: time)) \(dateFormatter.string(from: date))"
    }

    //Data
    private var timeFormatter: DateFormatter!
    private var dateFormatter: DateFormatter!
    private var delegate: PlaceCartDelegate!

    private var container: PlaceCartController.CartContainer {
        return delegate.takeCartContainer()
    }
    private var cart: Cart {
        return delegate.takeCart()
    }

    private func refresh() {

        if let summary = delegate.takeSummary() {
            scheduleView.update(by: summary.Schedule)
        }

        let now = Date()
        if (cart.buildCompleteAt() < now) {
            setup(dateAndTime: now)
        } else {
            setup(dateAndTime: cart.buildCompleteAt())
        }
    }
}
extension PlaceCartDateContainer {

    private func setup(dateAndTime date: Date) {

        var hours = date.hours()
        var minutes = (date.minutes() / 5) * 5 + 5

        if (minutes > 59) {
            hours += 1
            minutes = minutes % 60
        }

        timePicker.selectRow(hours % 24, inComponent: 0, animated: true)
        timePicker.selectRow(minutes / 5, inComponent: 1, animated: true)

        setup(hours: hours, minutes: minutes)

        setup(date: date)
    }
    private func setup(date: Date) {

        cart.date = date

        scheduleView.focus(on: date)
        updateDateTimeLabel()
    }
    private func setup(minutes: Int) {
        setup(hours: cart.time.hours(), minutes: minutes)
    }
    private func setup(hours: Int) {
        setup(hours: hours, minutes: cart.time.minutes())
    }
    private func setup(hours: Int, minutes: Int) {
        cart.time = timeFormatter.date(from: "\(String(format: "%02d", hours % 24)):\(String(format: "%02d", minutes % 60))")!

        updateDateTimeLabel()
    }
}
// MARK: Segment
extension PlaceCartDateContainer {
    @objc private func changeDate() {

        let index = dateChecker.selectedSegmentIndex

        if (0 == index) {
            let date = Calendar.current.date(byAdding: .minute, value: 10, to: Date())!
            setup(dateAndTime: date)
        } else if(1 == index) {
            setup(date: Date().noon)
        } else if (2 == index) {
            setup(date: Date().tomorrow)
        }

        timePicker.isHidden = 0 == index
    }
}
extension PlaceCartDateContainer: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (0 == component) {
            return String(format: "%02d", row)
        } else if (1 == component) {
            return String(format: "%02d", row * 5)
        } else {
            return "0"
        }
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if (0 == component) {
            setup(hours: row)
        } else if (1 == component) {
            setup(minutes: row * 5)
        }
    }
}
extension PlaceCartDateContainer: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if (0 == component) {
            return 24
        } else if (1 == component) {
            return 12
        } else {
            return 0
        }
    }
}
extension PlaceCartDateContainer: PlaceCartContainerCell {
    public func viewDidAppear() {}
    public func viewDidDisappear() {}
    public func updateData(with delegate: PlaceCartDelegate) {
        refresh()
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
