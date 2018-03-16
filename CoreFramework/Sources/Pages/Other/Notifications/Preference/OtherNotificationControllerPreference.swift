//
//  OtherNotificationControllerPreference.swift
//  CoreFramework
//
//  Created by Алексей on 16.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class OtherNotificationControllerPreference: UITableViewCell {

    public static let identifier = Guid.new
    public static func register(in table: UITableView) {
        let nib = UINib(nibName: String.tag(OtherNotificationControllerPreference.self), bundle: Bundle.coreFramework)
        table.register(nib, forCellReuseIdentifier: identifier)
    }

    //UI
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueSwitch: UISwitch!

    //Service
    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    //Data
    private var title: Localizable? = nil
    private var value: Bool = false
    private var key: String = String.empty
    public var delegate: OtherNotificationControllerDelegate? = nil

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.contentBackground

        titleLabel.font = themeFonts.default(size: .subhead)
        titleLabel.textColor = themeColors.contentBackgroundText

        valueSwitch.onTintColor = themeColors.actionMain
        valueSwitch.backgroundColor = themeColors.contentBackground

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnRow))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    open func setup(title: Localizable, value: Bool, key: String) {

        self.title = title
        self.value = value
        self.key = key

        refresh()
    }
    private func refresh() {

        titleLabel.text = title?.localized ?? String.empty
        valueSwitch.isOn = value
    }

    @objc private func tapOnRow() {
        valueSwitch.setOn(!value, animated: true)
        changeValue()
    }
    @IBAction private func changeValue() {

        self.value = valueSwitch.isOn

        let key = self.key
        let value = self.value

        guard let request = delegate?.change(key: key, on: value) else {
            return
        }
        
        request.async(.background, completion: { response in
            DispatchQueue.main.async {

                if (response.isFail) {
                    self.value = value
                    self.valueSwitch.setOn(value, animated: true)
                }
            }
        })
    }
}
