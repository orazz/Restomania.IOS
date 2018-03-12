//
//  PlaceCard.swift
//  Kuzina
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit

open class SearchPlaceCard: UITableViewCell {

    public static let height = CGFloat(100)

    @IBOutlet private weak var placeImage: CachedImage?
    @IBOutlet private weak var name: UILabel?
    @IBOutlet private weak var location: UILabel?
    @IBOutlet private weak var workingHours: UILabel?

    public let themeColors = DependencyResolver.resolve(ThemeColors.self)
    public let themeFonts = DependencyResolver.resolve(ThemeFonts.self)
    public let themeImages = DependencyResolver.resolve(ThemeImages.self)

    private var _summary: PlaceSummary!

    open override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.contentBackground

        name?.font = themeFonts.bold(size: .head)
        name?.textColor = themeColors.contentBackgroundText

        workingHours?.font = themeFonts.default(size: .subhead)
        workingHours?.textColor = themeColors.contentBackgroundText

        location?.font = themeFonts.default(size: .subhead)
        location?.textColor = themeColors.contentBackgroundText
    }
    public func update(summary: PlaceSummary) {
        _summary = summary

        refresh()
    }
    private func refresh() {

        placeImage?.setup(url: _summary.Image)
        name?.text = _summary.Name
        workingHours?.text = take(_summary.Schedule)
        location?.text = format(_summary.Location)
    }
    private func format(_ location: PlaceLocation) -> String {

        let parts = [location.Street, location.House].where({ !String.isNullOrEmpty($0) }).map({ $0! })

        return parts.joined(separator: ", ")
    }
    private func take(_ workingHours: ShortSchedule) -> String {

        let value = workingHours.takeToday()
        if (String.isNullOrEmpty(value)) {
            return ScheduleDisplay.Localization.holiday.localized
        }

        return value
    }
}
