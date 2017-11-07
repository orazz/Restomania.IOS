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

    private var _days = [ScheduleDisplayCell]()

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

        _days = [
            ScheduleDisplayCell.create(for: .monday, with: schedule.monday),
            ScheduleDisplayCell.create(for: .tuesday, with: schedule.tuesday),
            ScheduleDisplayCell.create(for: .wednesday, with: schedule.wednesday),
            ScheduleDisplayCell.create(for: .thursday, with: schedule.thursday),
            ScheduleDisplayCell.create(for: .friday, with: schedule.friday),
            ScheduleDisplayCell.create(for: .saturday, with: schedule.saturday),
            ScheduleDisplayCell.create(for: .sunday, with: schedule.sunday)
        ]

        contentView.reloadData()

        contentView.scrollToItem(at: IndexPath(item: _days.index(where: { $0.isToday })!, section: 0), at: .centeredHorizontally, animated: true)
    }
}
extension ScheduleDisplay: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: ScheduleDisplayCell.width, height: ScheduleDisplayCell.height)
    }
}
extension ScheduleDisplay: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _days.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        return _days[indexPath.item]
    }

}
