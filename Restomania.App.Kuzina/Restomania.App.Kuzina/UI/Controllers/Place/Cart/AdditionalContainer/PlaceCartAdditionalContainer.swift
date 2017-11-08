//
//  PlaceCartAdditionalContainer.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class PlaceCartAdditionalContainer: UITableViewCell {

    private static let nibName = "PlaceCartAdditionalContainerView"
    public static func create(for delegate: PlaceCartDelegate) -> PlaceCartContainerCell {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let cell = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceCartAdditionalContainer

        cell.delegate = delegate
        cell.setupMarkup()

        return cell
    }

    //UI hooks
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var underlineView: UIView!

    //Data
    private var delegate: PlaceCartDelegate! {
        didSet {
            apply()
        }
    }
    private var container: PlaceCartController.CartContainer {
        return delegate.takeContainer()
    }

    private func apply() {

    }
    private func setupMarkup() {

        titleLabel.font = ThemeSettings.Fonts.default(size: .head)
        titleLabel.textColor = ThemeSettings.Colors.main

        textField.font = ThemeSettings.Fonts.default(size: .caption)
        textField.textColor = ThemeSettings.Colors.main
        textField.delegate = self
        textField.text = container.comment

        underlineView.backgroundColor = ThemeSettings.Colors.main
    }
}
extension PlaceCartAdditionalContainer: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        container.comment = textField.text ?? String.empty
    }
}
extension PlaceCartAdditionalContainer: PlaceCartContainerCell {
    public func viewDidAppear() {}
    public func viewDidDisappear() {}
    public func updateData(with: PlaceCartDelegate) {}
}
extension PlaceCartAdditionalContainer: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return 110
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
