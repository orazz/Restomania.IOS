//
//  OnePlaceMainLocationCellOneLine.swift
//  FindMe
//
//  Created by Алексей on 17.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class OnePlaceMainLocationCellOneLine: UITableViewCell {

    public static let identifier = Guid.new
    public static let height = CGFloat(25)
    private static let nibName = "OnePlaceMainLocationCellOneLine"
    public static func register(in table:UITableView) {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        table.register(nib, forCellReuseIdentifier: identifier)
    }

    //MARK: UI elements
    @IBOutlet public weak var NameLabel: UILabel!
    @IBOutlet public weak var ValueLabel: UILabel!

    //MARK: Data & Services
    private var _isSetupMarkup = false

    public func setup(data: OnePlaceMainLocationCell.LocationLine){

        setupStyles()

        NameLabel.text = data.name
        ValueLabel.text = data.displayValue
    }
    private func setupStyles() {

        if (_isSetupMarkup) {
            return
        }
        _isSetupMarkup = true

        NameLabel.font = ThemeSettings.Fonts.bold(size: .caption)
        ValueLabel.font = ThemeSettings.Fonts.default(size: .caption)
    }
}
