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

    public static let height = CGFloat(45)
    public static let identifier = "\(String.tag(ScheduleDisplayCell.self))-\(Guid.new)"
    private static let Localize = Localization.UIElements.Schedule.self
    private static let nibName = "\(String.tag(ScheduleDisplayCell.self))View"
    public static func register(in collectionView: UICollectionView) {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }

    //UI elements
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!

    //Service

    //Data
    private static let today = DayOfWeek(rawValue: Date().dayOfWeek())
    private var day: DayOfWeek!
    private var value: String!
    private var isToday: Bool {
        return day == ScheduleDisplayCell.today
    }

    public func update(for day: DayOfWeek, by value: String) {

        self.day = day
        self.value = value

        updateStyles()
    }
    private func updateStyles() {

        if (String.isNullOrEmpty(value)) {
            valueLabel.text = ScheduleDisplayCell.Localize.holiday
        } else {
            valueLabel.text = value
        }

        titleLabel.text = ScheduleDisplayCell.title(for: day).uppercased()
        if (isToday) {
            titleLabel.font = ThemeSettings.Fonts.bold(size: .subhead)
            valueLabel.font = ThemeSettings.Fonts.bold(size: .caption)
        } else {
            titleLabel.font = ThemeSettings.Fonts.default(size: .subhead)
            valueLabel.font = ThemeSettings.Fonts.default(size: .caption)
        }
    }

    public static func title(for day: DayOfWeek) -> String {

        switch (day) {
            case .sunday:
                return Localize.sunday
            case .monday:
                return Localize.monday
            case .tuesday:
                return Localize.tuesday
            case .wednesday:
                return Localize.wednesday
            case .thursday:
                return Localize.thursday
            case .friday:
                return Localize.friday
            case .saturday:
                return Localize.saturday
        }
    }
    public static func titleWidth(for day: DayOfWeek) -> CGFloat {

        let title = ScheduleDisplayCell.title(for: day).uppercased()

        return title.width(containerHeight: ScheduleDisplayCell.height, font: ThemeSettings.Fonts.bold(size: .title)) + 5 + 5
    }
}
