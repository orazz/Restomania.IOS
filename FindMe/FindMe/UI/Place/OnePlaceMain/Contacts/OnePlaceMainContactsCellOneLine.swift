//
//  OnePlaceMainContactsCellOneLine.swift
//  FindMe
//
//  Created by Алексей on 17.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class OnePlaceMainContactsCellOneLine: UITableViewCell {

    public static let identifier = Guid.new
    public static let height = CGFloat(25)
    private static let nibName = "OnePlaceMainContactsCellOneLine"
    public static func register(in tableview: UITableView) {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        tableview.register(nib, forCellReuseIdentifier: identifier)
    }

    //MARK: UI elements
    @IBOutlet public weak var Name: UILabel!
    @IBOutlet public weak var Value: UILabel!

    //MARK: Data
    private var _contact: OnePlaceMainContactsCell.ContactLine? = nil

    private var _isSetupMarkup: Bool = false


    public func setup(data: OnePlaceMainContactsCell.ContactLine) {

        setupStyles()

        _contact = data

        Name.text = data.name
        Value.text = data.displayValue
    }
    private func setupStyles() {

        if (_isSetupMarkup){
            return
        }
        _isSetupMarkup = true

        Name.textColor = ThemeSettings.Colors.blackText
        Name.font = ThemeSettings.Fonts.bold(size: .caption)

        Value.textColor = ThemeSettings.Colors.main
        Value.font = ThemeSettings.Fonts.default(size: .caption)

        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(openLink))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }

    @objc private func openLink() {

        if  let link = _contact?.link,
            let url = URL(string: link) {
            UIApplication.shared.openURL(url)
        }
    }
}
