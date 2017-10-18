//
//  FMTextField.swift
//  FindMe
//
//  Created by Алексей on 18.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary
import CoreGraphics

@objc public protocol FMTextFieldDelegate {

    @objc optional func startEdit(_ textField: UITextField)
    @objc optional func endEdit(_ textField: UITextField, value: String?)
}
public class FMTextField: UIView {

    public static let height = 35.0
    private let scaleFactor = CGFloat(1/1.5)
    private let nibName = "FMTextField"


    //MARK: UIElements
    @IBOutlet public weak var contentView: UIView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var contentField: UITextField!
    @IBOutlet public weak var dividerView: UIView!


    //MARK: Properties
    public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    public var text: String? {
        get {
            return contentField.text
        }
        set {
            contentField.text = newValue

            updateTitleLabel()
        }
    }
    public var valueType: ValueType! {
        didSet {

            switch (valueType) {

                case .email:
                    contentField.keyboardType = .emailAddress
                case .url:
                    contentField.keyboardType = .URL
                case .number:
                    contentField.keyboardType = .numberPad
                default:
                    contentField.keyboardType = .default
            }
        }
    }

    public var delegate: FMTextFieldDelegate?
    public var focusedTitleColor: UIColor! {
        didSet {
            updateColors()
        }
    }
    public var defaultTitleColor: UIColor! {
        didSet {
            updateColors()
        }
    }

    public private (set) var titleIsFocused: Bool = false


    public override init(frame: CGRect) {
        super.init(frame: frame)

        stylize()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        stylize()
    }
    private func stylize() {

        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.setContraint(height: CGFloat(FMTextField.height))


        titleIsFocused = false
        titleLabel.text = nil
        titleLabel.font = ThemeSettings.Fonts.default(size: .headline)
        contentField.text = nil
        contentField.font = ThemeSettings.Fonts.default(size: .headline)
        valueType = .text

        focusedTitleColor = ThemeSettings.Colors.main
        defaultTitleColor = ThemeSettings.Colors.blackText


    }

    //MARK: Methods
    public func focus() {
        contentField.becomeFirstResponder()
    }
    public func blur() {
        contentField.resignFirstResponder()
    }

    //MARK: Actions
    private func updateColors() {

        if (titleIsFocused) {
            titleLabel.textColor = focusedTitleColor
            dividerView.backgroundColor = focusedTitleColor
        }
        else {
            titleLabel.textColor = defaultTitleColor
            dividerView.backgroundColor = defaultTitleColor
        }

        contentField.textColor = defaultTitleColor
    }
    @IBAction private func focusField() {
        focus()
    }

    //MARK: Move title
    private func updateTitleLabel() {

        if (String.isNullOrEmpty(contentField.text)) {

            if (contentField.isFirstResponder) {
                moveTitleTop()
            }
            else {
                moveTitleBottom()
            }
        }
        else {
            moveTitleTop()
        }
    }
    private func moveTitleTop() {

        if (titleIsFocused) {
            return
        }
        titleIsFocused = true

        let topOffset = titleLabel.frame.height * (1.8 - scaleFactor)
        let rightOffset = titleLabel.frame.width * (1.0 - scaleFactor) / 2

        var transform = CGAffineTransform.init(translationX: -rightOffset, y: -topOffset)
        transform = transform.scaledBy(x: scaleFactor, y: scaleFactor)
        transformTitle(by: transform, color: focusedTitleColor)
    }
    private func moveTitleBottom() {

        if (!titleIsFocused){
            return
        }
        titleIsFocused = false

        let transform = CGAffineTransform(translationX: 0, y: 0)
        transformTitle(by: transform, color: defaultTitleColor)
    }
    private func transformTitle(by transform:CGAffineTransform, color: UIColor) {

        UIView.animate(withDuration: 0.3, animations: {

                self.titleLabel.transform = transform
                self.titleLabel.textColor = color
                self.dividerView.backgroundColor = color
            })
    }
}

extension FMTextField: UITextFieldDelegate {

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        updateTitleLabel()

        delegate?.startEdit?(textField)
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        updateTitleLabel()

        delegate?.endEdit?(textField, value: textField.text)
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        blur()
        return true
    }
}

extension FMTextField {

    public enum ValueType {

        case text
        case email
        case url
        case number
    }
}
