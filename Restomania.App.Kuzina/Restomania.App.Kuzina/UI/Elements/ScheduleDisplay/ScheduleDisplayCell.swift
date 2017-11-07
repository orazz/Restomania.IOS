//
//  ScheduleDisplayCell.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class ScheduleDisplayCell: UICollectionViewCell {

    public static let height = CGFloat(70)
    public static let width = CGFloat(175)
    private static let nibName = "ScheduleDisplayCellView"
    public static func create(for day: DayOfWeek, with value: String) -> ScheduleDisplayCell {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance = nib.instantiate(withOwner: nil, options: nil).first! as! ScheduleDisplayCell

        instance.apply(day, with: value)

        return instance
    }

    //UI elements
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!

    //Data
    public var isToday: Bool = false
    private var _day: DayOfWeek!
    private var _value: String!

    private func apply(_ day: DayOfWeek, with value: String) {

        _day = day
        _value = value

        setupMarkup()
    }
    private func setupMarkup() {

        if (String.isNullOrEmpty(_value)) {
            valueLabel.text = _value
        } else {
            valueLabel.text = NSLocalizedString("holiday", comment: "Schedule")
        }

        titleLabel.text = title(for: _day)

        let weekday = Date().dayOfWeek()
        let now = DayOfWeek(rawValue: weekday)
        if (now != _day) {
            titleLabel.font = ThemeSettings.Fonts.default(size: .title)
            valueLabel.font = ThemeSettings.Fonts.default(size: .subhead)
        } else {
            isToday = true
            titleLabel.font = ThemeSettings.Fonts.bold(size: .title)
            valueLabel.font = ThemeSettings.Fonts.bold(size: .subhead)
        }
    }
    private func title(for day: DayOfWeek) -> String {

        switch (day) {
            case .monday:
                return "Понедельник"
            case .tuesday:
                return "Вторник"
            case .wednesday:
                return "Среда"
            case .thursday:
                return "Четверг"
            case .friday:
                return "Пятница"
            case .saturday:
                return "Суббота"
            case .sunday:
                return "Воскресенье"
        }
    }
}
