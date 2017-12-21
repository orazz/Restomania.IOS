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
    public static let identifier = "\(String.tag(ScheduleDisplayCell.self))-\(Guid.new)"
    private static let nibName = "ScheduleDisplayCellView"
    public static func register(in collectionView: UICollectionView) {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }

    //UI elements
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!

    //Data
    public var isToday: Bool = false
    private var _day: DayOfWeek!
    private var _value: String!

    public func update(for day: DayOfWeek, by value: String) {

        _day = day
        _value = value

        setupMarkup()
    }
    private func setupMarkup() {

        if (String.isNullOrEmpty(_value)) {
            valueLabel.text = Localization.UIElements.Schedule.holiday
        } else {
            valueLabel.text = _value
        }

        titleLabel.text = ScheduleDisplayCell.title(for: _day).uppercased()

        let weekday = Date().dayOfWeek()
        let now = DayOfWeek(rawValue: weekday - 1)
        if (now != _day) {
            titleLabel.font = ThemeSettings.Fonts.default(size: .title)
            valueLabel.font = ThemeSettings.Fonts.default(size: .subhead)
        } else {
            isToday = true
            titleLabel.font = ThemeSettings.Fonts.bold(size: .title)
            valueLabel.font = ThemeSettings.Fonts.bold(size: .subhead)
        }
    }
    public static func title(for day: DayOfWeek) -> String {

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
    public static func titleWidth(for day: DayOfWeek) -> CGFloat {

        let title = ScheduleDisplayCell.title(for: day).uppercased()

        return title.width(containerHeight: ScheduleDisplayCell.height, font: ThemeSettings.Fonts.bold(size: .title)) + 5 + 5
    }
}
