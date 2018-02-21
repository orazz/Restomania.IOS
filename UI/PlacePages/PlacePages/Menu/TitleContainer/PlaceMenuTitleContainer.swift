//
//  PlaceMenuTitleContainer.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 07.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import CoreDomains

public class PlaceMenuTitleContainer: UITableViewCell {

    private static let nibName = "PlaceMenuTitleContainerView"
    public static func create(with delegate: PlaceMenuDelegate) -> PlaceMenuTitleContainer {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceMenuTitleContainer

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
        dimmerView.backgroundColor = ThemeSettings.Colors.background

        //Title view
        // - round borders
        titleView.layer.cornerRadius = 5
        titleView.layer.borderWidth = 1
        titleView.layer.borderColor = ThemeSettings.Colors.additional.cgColor
        titleView.backgroundColor = ThemeSettings.Colors.additional
        // - shadow
        titleView.layer.shadowColor = ThemeSettings.Colors.additional.cgColor
        titleView.layer.shadowOpacity = 0.13
        titleView.layer.shadowOffset = CGSize.init(width: 3, height: 3)
        titleView.layer.shadowRadius = 5
        titleView.layer.shouldRasterize = true

        //Name
        nameLabel.text = String.empty
        nameLabel.font = ThemeSettings.Fonts.bold(size: .subhead)
        nameLabel.textColor = ThemeSettings.Colors.main

        //Wokings hours
        workingHoursLabel.text = String.empty
        workingHoursLabel.font = ThemeSettings.Fonts.default(size: .caption)
        workingHoursLabel.textColor = ThemeSettings.Colors.main
    }
}

// MARK: Actions
extension PlaceMenuTitleContainer {
    @IBAction private func goBack() {
        delegate.goBack()
    }
    @IBAction private func goPlaceInfo() {
        delegate.goToPlace()
    }
}

// MARK: Protocols
extension PlaceMenuTitleContainer: PlaceMenuCellsProtocol {

    public func viewDidAppear() {}
    public func viewDidDisappear() {}
    public func dataDidLoad(delegate: PlaceMenuDelegate) {
        _summary = delegate.takeSummary()
    }
}
extension PlaceMenuTitleContainer: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return 265
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
