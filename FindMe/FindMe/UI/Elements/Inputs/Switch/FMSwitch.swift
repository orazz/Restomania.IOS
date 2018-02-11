//
//  FMSwitch.swift
//  FindMe
//
//  Created by Алексей on 19.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

@objc public protocol FMSwitchDelegate {

    @objc optional func changeValue(_ switch: UISwitch, value: Bool)
}
public class FMSwitch: UIView {

    public static let height = CGFloat(35)
    private let nibName = "FMSwitch"



    //MARK: UI elements
    @IBOutlet public weak var contentView: UIView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var switchControl: UISwitch!



    //MARK: Callbacks
    public var delegate: FMSwitchDelegate?
    public var onChangeEvent: ((_: UISwitch, _: Bool) -> Void)?



    //MARK: properties
    public var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    public var value: Bool {
        get {
            return switchControl.isOn
        }
        set {
            switchControl.isOn = newValue
        }
    }


    public override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }
    private func setup() {

        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.setContraint(height: CGFloat(FMTextField.height))


        titleLabel.font = ThemeSettings.Fonts.default(size: .subhead)
        titleLabel.text = nil

        switchControl.onTintColor = ThemeSettings.Colors.main
        switchControl.tintColor = ThemeSettings.Colors.main
        switchControl.isOn = true
        switchControl.addTarget(self, action: #selector(changeValue), for: .valueChanged)
    }

    //MARK: Actions
    @IBAction private func tapAndChangeSwitch() {

        switchControl.toogle(animated: true)

        notify()
    }
    @objc private func changeValue() {
        notify()
    }
    private func notify() {

        delegate?.changeValue?(switchControl, value: switchControl.isOn)
        onChangeEvent?(switchControl, switchControl.isOn)
    }
}
