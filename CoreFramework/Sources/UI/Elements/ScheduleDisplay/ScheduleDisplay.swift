//
//  ScheduleDisplay.swift
//  CoreFramework
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import Gloss

public class ScheduleDisplay: UIView {

    //UI
    @IBOutlet private weak var contentView: UICollectionView!

    //Data
    private var schedule = ShortSchedule()
    private var days = [DayOfWeek]()
    private var lastFocusDay = Date().dayOfWeek()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initialize()
    }
    private func initialize() {

        connect()

        if let _ = self.getConstant(.height) {
            self.setContraint(.height, to: ScheduleDisplayCell.height)
        }

        ScheduleDisplayCell.register(in: contentView)
        contentView.dataSource = self
        contentView.delegate = self
    }
    private func connect() {

        Bundle.coreFramework.loadNibNamed(String.tag(ScheduleDisplay.self), owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.setContraint(height: ScheduleDisplayCell.height)
    }

    public func update(by schedule: ShortSchedule) {

        self.schedule = schedule

        let weekStart = Int(Localization.weekStartFrom.localized) ?? 0
        self.days = []
        for offset in 0..<7 {
            days.append(DayOfWeek(rawValue: (weekStart + offset) % 7)!)
        }

        contentView.reloadData()

        focus(on: lastFocusDay)
    }
    public func focus(on day: DayOfWeek) {

        lastFocusDay = day

        guard let position = days.index(where: { $0 == day }) else {
            return
        }

        contentView.scrollToItem(at: IndexPath(item: position, section: 0), at: .centeredHorizontally, animated: true)
    }
}
extension ScheduleDisplay: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let index = days[indexPath.item]
        let width = ScheduleDisplayCell.titleWidth(for: index)
        return CGSize.init(width: width, height: ScheduleDisplayCell.height)
    }
}
extension ScheduleDisplay: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let day = days[indexPath.item]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleDisplayCell.identifier, for: indexPath) as! ScheduleDisplayCell
        cell.update(for: day, by: "\(schedule.takeDay(day))")

        return cell
    }
}
extension ScheduleDisplay {
    internal enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(ScheduleDisplay.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        case holiday = "Holiday"
        case weekStartFrom = "WeekStartFrom"

        case sunday = "Days.Sunday"
        case monday = "Days.Monday"
        case tuesday = "Days.Tuesday"
        case wednesday = "Days.Wednesday"
        case thursday = "Days.Thursday"
        case friday = "Days.Friday"
        case saturday = "Days.Saturday"
    }
}
extension ShortSchedule {

    public var todayRepresentation: String {

        var day = self.takeToday()
        if (String.isNullOrEmpty(day)) {
            day = ScheduleDisplay.Localization.holiday.localized
        }

        return day
    }
}
