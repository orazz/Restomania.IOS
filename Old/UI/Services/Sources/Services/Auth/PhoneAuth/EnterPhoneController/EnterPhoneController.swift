//
//  EnterPhoneController.swift
//  UIServices
//
//  Created by Алексей on 11.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import InputMask
import CoreTools
import UITools
import UIElements
//import FirebaseAuth

internal class EnterPhoneController: UIViewController {

    //UI
    @IBOutlet private weak var enterPhoneLabel: UILabel!
    @IBOutlet private weak var phoneField: UITextField!
    @IBOutlet private weak var sendButtonCode: DefaultButton!
    private var maskedDelegate: MaskedTextFieldDelegate!

    //Services
    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    //Data
    private let _tag = String.tag(EnterPhoneController.self)
    private let handler: AuthHandler

    internal init(_ handler: AuthHandler) {

        self.handler = handler

        super.init(nibName: String.tag(EnterPhoneController.self), bundle: Bundle.uiServices)
    }
    internal required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    //Life circle
    public override func loadView() {
        super.loadView()

        loadMarkup()
    }
    private func loadMarkup() {

        view.backgroundColor = themeColors.contentBackground

        enterPhoneLabel.text = Localization.labelsEnterPhone.localized
        enterPhoneLabel.font = themeFonts.default(size: .title)
        enterPhoneLabel.textColor = themeColors.contentBackgroundText

        maskedDelegate = MaskedTextFieldDelegate(format: "{+7} ([000]) [000] [00] [00]")
        maskedDelegate.listener = self
        phoneField.font = themeFonts.default(size: .subhead)
        phoneField.textColor = themeColors.contentBackgroundText
        phoneField.delegate = maskedDelegate
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
extension EnterPhoneController: MaskedTextFieldDelegateListener {

    open func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        print(value)
    }
}
extension EnterPhoneController {
    @IBAction private func sendCode() {

        guard let phone = phoneField.text else {
            return
        }

//        let provider = PhoneAuthProvider.provider()
//        provider.verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//
////            self.verificationID = verificationID!
//            print("Verification Id: \(verificationID!)")
//        }
    }
    @IBAction private func closeKeyboard() {
        view.endEditing(true)
    }
}
extension EnterPhoneController {
    internal enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(EnterPhoneController.self)
        }
        public var bundle: Bundle {
            return Bundle.uiServices
        }

        case title = "Title"

        case labelsEnterPhone = "Labels.EnterPhone"

        case fieldsPhonePlacesholder = "Fields.Phone.Placeholder"

        case buttonsSendCode = "Buttons.SendCode"

        case alertsNotCorrectPhone = "Alerts.NotCorrectPhone"
        case alertsVerificationProblem = "Alerts.VerificationProblem"
    }
}
