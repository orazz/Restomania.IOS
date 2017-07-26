//
//  PlaceCard.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import IOSLibrary

public class PlaceCard: UITableViewCell {

    public static var xibName = "PlaceCard"
    public static let identifier = "PlaceCard-\(Guid.New)"
    public static let height = CGFloat(150)

    @IBOutlet weak var placeImage: WrappedImage!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var workingHours: UILabel!

    private var _summary: PlaceSummary!
    private let _theme: ThemeSettings = AppSummary.current.theme

    public func initialize(summary: PlaceSummary) {

        _summary = summary

        setupStyles()
        refresh()
    }
    private func setupStyles() {

        name.font = UIFont(name: _theme.susanBoldFont, size: _theme.titleFontSize)
        name.textColor = _theme.whiteColor

        workingHours.font = UIFont(name: _theme.susanBookFont, size: _theme.subheadFontSize)
        workingHours.textColor = _theme.whiteColor

        location.font = UIFont(name: _theme.susanBookFont, size: _theme.subheadFontSize)
        location.textColor = _theme.whiteColor
    }
    private func refresh() {

        placeImage.setup(url: _summary.Image)
        name.text = _summary.Name
        workingHours.text = take(_summary.Schedule)
        location.text = format(_summary.Location)
    }
    private func format(_ location: PlaceLocation) -> String {

        let parts = [location.Street, location.House].where({ !String.IsNullOrEmpty($0) })
                                                     .map({ $0! })

        return parts.joined(separator: ", ")
    }
    private func take(_ workingHours: ShortSchedule) -> String {

        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date)

        let value = workingHours.dayValue(day)

        if (String.IsNullOrEmpty(value)) {
            return NSLocalizedString("holiday", comment: "Schedule")
        }

        return value
    }
}
