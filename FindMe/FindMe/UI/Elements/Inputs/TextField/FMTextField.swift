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

public class FMTextField: UIView {

    public static let height = 40.0
    private let scaleFactor = CGFloat(1/1.2)
    private var topOffset = CGFloat(15)
    private var rightOffset = CGFloat(15)
    private let nibName = "FMTextField"


    //MARK: UIElements
    @IBOutlet public weak var ContentView: UIView!
    @IBOutlet public weak var TitleLabel: UILabel!
    @IBOutlet public weak var ContentField: UITextField!
    @IBOutlet public weak var DividerView: UIView!


    //MARK: Properties
    public var title: String? {
        didSet {
            TitleLabel.text = title
        }
    }
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

    public var titleIsFocused: Bool = false


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
        self.addSubview(ContentView)
        ContentView.frame = self.bounds
        ContentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        TitleLabel.font = ThemeSettings.Fonts.default(size: .headline)
        ContentField.font = ThemeSettings.Fonts.default(size: .headline)

        //Magic count how move label
        topOffset = TitleLabel.frame.height * (2.0 - scaleFactor)
        rightOffset =  TitleLabel.frame.width * (1.0 - scaleFactor) / 2

        focusedTitleColor = ThemeSettings.Colors.main
        defaultTitleColor = ThemeSettings.Colors.blackText
    }


    //MARK: Actions
    private func updateColors() {

        if (titleIsFocused) {
            TitleLabel.textColor = focusedTitleColor
            DividerView.backgroundColor = focusedTitleColor
        }
        else {
            TitleLabel.textColor = defaultTitleColor
            DividerView.backgroundColor = defaultTitleColor
        }

        ContentField.textColor = defaultTitleColor
    }
    @IBAction private func focusField() {
        ContentField.becomeFirstResponder()
    }

    //MARK: Move title
    private func moveTitleTop() {

        if (titleIsFocused) {
            return
        }
        titleIsFocused = true

        var transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        transform = transform.translatedBy(x: -rightOffset, y: -topOffset)
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

                self.TitleLabel.transform = transform
                self.TitleLabel.textColor = color
                self.DividerView.backgroundColor = color
            })
    }
}

extension FMTextField: UITextFieldDelegate {

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTitleTop()
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {

        if (String.isNullOrEmpty(textField.text)){
            moveTitleBottom()
        }
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        return true
    }
}
