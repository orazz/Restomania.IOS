//
//  ScheduleDisplayCell.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class ScheduleDisplayCell: UICollectionViewCell {

    public static let height = CGFloat(45)
    public static let identifier = Guid.new
    private static let Localize =  ScheduleDisplay.Localization.self
    private static let nibName = "\(String.tag(ScheduleDisplayCell.self))"
    public static func register(in collectionView: UICollectionView) {

        let nib = UINib(nibName: nibName, bundle: Bundle.coreFramework)
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }

    //UI elements
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!

    //Service
    private static let themeFonts = DependencyResolver.get(ThemeFonts.self)
    private let fonts = ScheduleDisplayCell.themeFonts

    //Data
    private static let today = Date().dayOfWeek()
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
            valueLabel.text = ScheduleDisplayCell.Localize.holiday.localized
        } else {
            valueLabel.text = value
        }

        titleLabel.text = ScheduleDisplayCell.title(for: day).uppercased()
        if (isToday) {
            titleLabel.font = fonts.bold(size: .subhead)
            valueLabel.font = fonts.bold(size: .caption)
        } else {
            titleLabel.font = fonts.default(size: .subhead)
            valueLabel.font = fonts.default(size: .caption)
        }
    }

    public static func title(for day: DayOfWeek) -> String {

        switch (day) {
            case .sunday:
                return Localize.sunday.localized
            case .monday:
                return Localize.monday.localized
            case .tuesday:
                return Localize.tuesday.localized
            case .wednesday:
                return Localize.wednesday.localized
            case .thursday:
                return Localize.thursday.localized
            case .friday:
                return Localize.friday.localized
            case .saturday:
                return Localize.saturday.localized
        }
    }
    public static func titleWidth(for day: DayOfWeek) -> CGFloat {

        let title = ScheduleDisplayCell.title(for: day).uppercased()

        return title.width(containerHeight: ScheduleDisplayCell.height, font: themeFonts.bold(size: .title)) + 5 + 5
    }
}
