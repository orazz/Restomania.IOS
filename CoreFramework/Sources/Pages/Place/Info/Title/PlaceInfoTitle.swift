//
//  PlaceInfoTitle.swift
//  CoreFramework
//
//  Created by Алексей on 07.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class PlaceInfoTitle: UITableViewCell {

    public static func create(with delegate: PlaceMenuDelegate) -> PlaceInfoTitle {

        let instance: PlaceInfoTitle = UINib.instantiate(from: String.tag(PlaceInfoTitle.self), bundle: Bundle.coreFramework)

        instance.delegate = delegate
        instance._summary = nil
        instance.setupMarkup()

        return instance
    }

    // MARK: UI Elements
    @IBOutlet private var placeImage: CachedImage!
    @IBOutlet private var dimmerView: UIView!
    @IBOutlet private var titleView: UIView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var workingHoursLabel: UILabel!

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    // MARK: Data & Services
    private var delegate: PlaceMenuDelegate!
    private var _summary: PlaceSummary? {
        didSet {
            if let summary = _summary {
                apply(summary)
            }
        }
    }

    private func apply(_ summary: PlaceSummary) {

        //Header
        placeImage.setup(url: summary.Image)
        nameLabel.text = summary.Name
        workingHoursLabel.text = summary.Schedule.todayRepresentation
    }
    private func setupMarkup() {
        dimmerView.backgroundColor = themeColors.contentBackground

        //Title view
        // - round borders
        titleView.layer.cornerRadius = 5
        titleView.layer.borderWidth = 1
        titleView.layer.borderColor = themeColors.contentBackground.cgColor
        titleView.backgroundColor = themeColors.contentBackground
        // - shadow
        titleView.layer.shadowColor = themeColors.contentBackground.cgColor
        titleView.layer.shadowOpacity = 0.13
        titleView.layer.shadowOffset = CGSize.init(width: 3, height: 3)
        titleView.layer.shadowRadius = 5
        titleView.layer.shouldRasterize = true

        //Name
        nameLabel.text = String.empty
        nameLabel.font = themeFonts.bold(size: .subhead)
        nameLabel.textColor = themeColors.contentText

        //Wokings hours
        workingHoursLabel.text = String.empty
        workingHoursLabel.font = themeFonts.default(size: .caption)
        workingHoursLabel.textColor = themeColors.contentText
    }
}

// MARK: Actions
extension PlaceInfoTitle {
    @IBAction private func goBack() {
        delegate.goBack()
    }
    @IBAction private func goPlaceInfo() {
        delegate.goToPlace()
    }
}

// MARK: Protocols
//extension PlaceInfoTitle: PlaceMenuElementProtocol {
//
//    public func viewWillAppear() {}
//    public func viewDidDisappear() {}
//    public func update(delegate: PlaceMenuDelegate) {
//        _summary = delegate.takeSummary()
//    }
//}
extension PlaceInfoTitle: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return 265
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
