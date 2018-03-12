//
//  PlaceCard.swift
//  Kuzina
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit

public class SearchPlaceCard: UITableViewCell {

    public static let height = CGFloat(100)

    @IBOutlet private weak var placeImage: CachedImage?
    @IBOutlet private weak var name: UILabel?
    @IBOutlet private weak var location: UILabel?
    @IBOutlet private weak var workingHours: UILabel?

    private let colorsTheme = DependencyResolver.resolve(ThemeColors.self)
    private let fontsTheme = DependencyResolver.resolve(ThemeFonts.self)
    private let themeImages = DependencyResolver.resolve(ThemeImages.self)

    private var _summary: PlaceSummary!

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = colorsTheme.contentBackground

        name?.font = fontsTheme.bold(size: .head)
        name?.textColor = colorsTheme.contentBackgroundText

        workingHours?.font = fontsTheme.default(size: .subhead)
        workingHours?.textColor = colorsTheme.contentBackgroundText

        location?.font = fontsTheme.default(size: .subhead)
        location?.textColor = colorsTheme.contentBackgroundText
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
