//
//  PlaceMenuTitleContainer.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 07.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class PlaceMenuTitleContainer: UITableViewCell {

    private static let nibName = "PlaceMenuTitleContainerView"
    public static func create(with navigator: UINavigationController) -> PlaceMenuTitleContainer {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceMenuTitleContainer

        instance._navigator = navigator
        instance._summary = nil
        instance.setupMarkup()

        return instance
    }

    // MARK: UI Elements
    @IBOutlet private var placeImage: WrappedImage!
    @IBOutlet private var dimmerView: UIView!
    @IBOutlet private var titleView: UIView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var workingHoursLabel: UILabel!

    // MARK: Data & Services
    private var _navigator: UINavigationController!
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
        _navigator.popViewController(animated: true)
    }
    @IBAction private func goPlaceInfo() {

        guard let summary = _summary else {
            return
        }

        let vc = PlaceInfoController.create(for: summary.ID)
        _navigator.pushViewController(vc, animated: true)
    }
}

// MARK: Protocols
extension PlaceMenuTitleContainer: PlaceMenuCellsProtocol {

    public func viewDidAppear() {}
    public func viewDidDisappear() {}
    public func dataDidLoad(delegate: PlaceMenuDelegate) {
        _summary = delegate.summary
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
