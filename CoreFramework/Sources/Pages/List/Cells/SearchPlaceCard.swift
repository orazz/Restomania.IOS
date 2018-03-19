//
//  PlaceCard.swift
//  CoreFramework
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit

open class SearchPlaceCard: UITableViewCell {

    public static let height = CGFloat(100)

    @IBOutlet public weak var placeImage: CachedImage?
    @IBOutlet public weak var name: UILabel?
    @IBOutlet public weak var location: UILabel?
    @IBOutlet public weak var workingHours: UILabel?
    @IBOutlet public weak var distance: DistanceLabel?

    public let themeColors = DependencyResolver.get(ThemeColors.self)
    public let themeFonts = DependencyResolver.get(ThemeFonts.self)
    public let themeImages = DependencyResolver.get(ThemeImages.self)

    public private(set) var summary: PlaceSummary!

    open override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.contentBackground

        name?.font = themeFonts.bold(size: .head)
        name?.textColor = themeColors.contentText

        workingHours?.font = themeFonts.default(size: .caption)
        workingHours?.textColor = themeColors.contentText

        location?.font = themeFonts.default(size: .subhead)
        location?.textColor = themeColors.contentText
    }
    public func update(summary: PlaceSummary) {
        self.summary = summary

        refresh()
    }
    private func refresh() {

        placeImage?.setup(url: summary.Image)
        name?.text = summary.Name
        workingHours?.text = take(summary.Schedule)
        location?.text = format(summary.Location)
        distance?.setup(lat: summary.Location.latitude, lng: summary.Location.longitude)
    }
    private func format(_ location: PlaceLocation) -> String {

        if (!String.isNullOrEmpty(location.address)) {
            return location.address
        }

        let parts = [location.city, location.street, location.house]
        return parts.where({ !String.isNullOrEmpty($0) })
                    .map({ $0 })
                    .joined(separator: ", ")
    }
    private func take(_ workingHours: ShortSchedule) -> String {

        let value = workingHours.takeToday()
        if (String.isNullOrEmpty(value)) {
            return ScheduleDisplay.Localization.holiday.localized
        }

        return value
    }
}
