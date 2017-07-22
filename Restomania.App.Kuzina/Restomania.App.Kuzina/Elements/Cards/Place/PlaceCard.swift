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
    @IBOutlet weak var workingHours: UILabel!
    @IBOutlet weak var location: UILabel!

    public var placeSummary: PlaceSummary!

    public func initialize(summary: PlaceSummary) {

        placeSummary = summary
        refresh()
    }
    private func refresh() {

        placeImage.setup(url: placeSummary.Image)
        name.text = placeSummary.Name
        workingHours.text = take(placeSummary.Schedule)
        location.text = format(placeSummary.Location)
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
