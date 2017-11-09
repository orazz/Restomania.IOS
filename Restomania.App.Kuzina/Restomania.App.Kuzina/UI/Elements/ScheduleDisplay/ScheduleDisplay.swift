//
//  ScheduleDisplay.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import Gloss

public class ScheduleDisplay: UIView {

    private let nibName = "ScheduleDisplayView"

    @IBOutlet private weak var contentView: UICollectionView!

    private var _schedule = ShortSchedule()

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

        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.setContraint(height: ScheduleDisplayCell.height)
    }

    public func update(by schedule: ShortSchedule) {

        _schedule = schedule
        contentView.reloadData()

        focus(on: Date())
    }
    public func focus(on day: Date) {
        //-1 - start from zero
        //-1 - return weekdat from 1 and from sunday
        focus(on: DayOfWeek(rawValue: day.dayOfWeek() - 1 - 1)!)
    }
    public func focus(on day: DayOfWeek) {
        contentView.scrollToItem(at: IndexPath(item: day.rawValue, section: 0), at: .centeredHorizontally, animated: true)
    }
}
extension ScheduleDisplay: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let index = dayIndex(for: indexPath.item)
        let width = ScheduleDisplayCell.titleWidth(for: DayOfWeek(rawValue: index)!)
        return CGSize.init(width: width, height: ScheduleDisplayCell.height)
    }
}
extension ScheduleDisplay: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let index = dayIndex(for: indexPath.item)
        let day = DayOfWeek(rawValue: index)!

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleDisplayCell.identifier, for: indexPath) as! ScheduleDisplayCell
        cell.update(for: day, by: valueOf(day: index, of: _schedule))

        return cell
    }
    private func valueOf(day: Int, of schedule: ShortSchedule) -> String {

        switch (day) {
            case 1:
                return schedule.monday
            case 2:
                return schedule.tuesday
            case 3:
                return schedule.wednesday
            case 4:
                return schedule.thursday
            case 5:
                return schedule.friday
            case 6:
                return schedule.saturday
            default:
                return schedule.sunday
        }
    }
    private func dayIndex(for day: Int) -> Int {
        return (day + 1 + 7) % 7
    }
}
