//
//  PlaceCard.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit

public class SearchPlaceCard: UITableViewCell {

    public static let height = CGFloat(150)
    public static let identifier = "\(String.tag(SearchPlaceCard.self))-\(Guid.new)"
    private static let nibName = "SearchPlaceCardCell"
    public static func register(in table: UITableView) {

        let nib = UINib.init(nibName: SearchPlaceCard.nibName, bundle: nil)
        table.register(nib, forCellReuseIdentifier: identifier)
    }

    @IBOutlet private weak var placeImage: CachedImage!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var location: UILabel!
    @IBOutlet private weak var workingHours: UILabel!

    private var _summary: PlaceSummary!

    public override func awakeFromNib() {
        super.awakeFromNib()

        name.font = ThemeSettings.Fonts.bold(size: .head)
        name.textColor = ThemeSettings.Colors.additional

        workingHours.font = ThemeSettings.Fonts.default(size: .subhead)
        workingHours.textColor = ThemeSettings.Colors.additional

        location.font = ThemeSettings.Fonts.default(size: .subhead)
        location.textColor = ThemeSettings.Colors.additional
    }
    public func update(summary: PlaceSummary) {
        _summary = summary

        refresh()
    }
    private func refresh() {

        placeImage.setup(url: _summary.Image)
        name.text = _summary.Name
        workingHours.text = take(_summary.Schedule)
        location.text = format(_summary.Location)
    }
    private func format(_ location: PlaceLocation) -> String {

        let parts = [location.Street, location.House].where({ !String.isNullOrEmpty($0) }).map({ $0! })

        return parts.joined(separator: ", ")
    }
    private func take(_ workingHours: ShortSchedule) -> String {

        let value = workingHours.takeToday()
        if (String.isNullOrEmpty(value)) {
            return Localization.UIElements.Schedule.holiday
        }

        return value
    }
}
