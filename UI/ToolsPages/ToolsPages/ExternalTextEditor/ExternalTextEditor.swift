//
//  ExternalTextEditor.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 18.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import UITools
import BaseApp

public class ExternalTextEditor: UIViewController {

    //Hooks
    public var onEdit: Action<String>?

    //UI
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var textField: UITextView!

    //Service
    private let themeColors = DependencyResolver.resolve(ThemeColors.self)

    //Data
    public override var title: String? {
        didSet {
            navigationBar?.topItem?.title = title
        }
    }
    public var text: String = String.empty {
        didSet {
            if (textField?.text != text) {
                textField?.text = text
            }
        }
    }
    private var backupText = String.empty

    public init() {
        super.init(nibName: "\(String.tag(ExternalTextEditor.self))View", bundle: Bundle.main)

        self.title = String.empty
    }
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    //Life circle
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupMarkup()
    }
    public func setupMarkup() {

        self.view.backgroundColor = themeColors.contentDivider

        containerView.backgroundColor = themeColors.contentBackground

        navigationBar.isTranslucent = false
        navigationBar.isOpaque = true
        navigationBar.backgroundColor = ThemeSettings.Colors.main
        navigationBar.barTintColor = ThemeSettings.Colors.main
        navigationBar.tintColor = ThemeSettings.Colors.additional
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: ThemeSettings.Colors.additional]

        textField.font = ThemeSettings.Fonts.default(size: .subhead)
        textField.delegate = self
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardOpen), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        navigationBar.topItem?.title = title

        backupText = text
        refresh()
        textField.becomeFirstResponder()
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }

    //Actions
    private func refresh() {
        if (String.isNullOrEmpty(text)) {
            textField.text = title
            textField.textColor = ThemeSettings.Colors.grey
        } else {
            textField.text = text
            textField.textColor = ThemeSettings.Colors.main
        }
    }
    @IBAction private func closeKeyboard() {
        view.endEditing(true)

        refresh()
    }
    @IBAction private func cancelEdit() {
        text = backupText
        closeEditor()
    }
    @IBAction private func completeEdit() {

        onEdit?(text)
        closeEditor()
    }
    private func closeEditor() {
        closeKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    @objc private func keyboardOpen(notification: NSNotification) {

        for constraint in textField.superview?.constraints ?? [] {
            if (constraint.identifier == "KeyboardOffset") {
                constraint.constant = prepareKeyboardHeight(for: notification)
                break
            }
        }
    }
}
extension ExternalTextEditor: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.textColor == ThemeSettings.Colors.grey) {
            textView.text = String.empty
            textView.textColor = ThemeSettings.Colors.main
        }
    }
    public func textViewDidChange(_ textView: UITextView) {
        update(from: textView)
    }
    public func textViewDidEndEditing(_ textView: UITextView) {
        update(from: textView)
    }
    private func update(from textView: UITextView) {
        self.text = textView.text ?? String.empty
    }
}
