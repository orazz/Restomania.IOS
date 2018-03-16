//
//  EnterPhoneAuthController.swift
//  UIServices
//
//  Created by Алексей on 11.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import InputMask
import FirebaseAuth

internal class EnterPhoneAuthController: UIViewController {

    //UI
    @IBOutlet private weak var enterPhoneLabel: UILabel!
    @IBOutlet private weak var phoneField: UITextField!
    @IBOutlet private weak var sendButtonCode: DefaultButton!
    private var maskedDelegate: MaskedTextFieldDelegate!
    private var interfaceLoader: InterfaceLoader!

    //Services
    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    //Data
    private let _tag = String.tag(EnterPhoneAuthController.self)
    private let handler: AuthHandler
    private var competeInput: Bool = false

    internal init(_ handler: AuthHandler) {

        self.handler = handler

        super.init(nibName: String.tag(EnterPhoneAuthController.self), bundle: Bundle.coreFramework)
    }
    internal required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    //Life circle
    public override func loadView() {
        super.loadView()

        maskedDelegate = MaskedTextFieldDelegate(format: "{+7} ([000]) [000] [00] [00]")
        maskedDelegate.listener = self

        interfaceLoader = InterfaceLoader(for: view)

        loadMarkup()
    }
    private func loadMarkup() {

        view.backgroundColor = themeColors.contentBackground

        enterPhoneLabel.text = Localization.labelsEnterPhone.localized
        enterPhoneLabel.font = themeFonts.default(size: .title)
        enterPhoneLabel.textColor = themeColors.contentText

        phoneField.font = themeFonts.default(size: .head)
        phoneField.textColor = themeColors.contentText
        phoneField.delegate = maskedDelegate
        phoneField.placeholder = Localization.fieldsPhonePlacesholder.localized

        sendButtonCode.setTitle(Localization.buttonsSendCode.localized, for: .normal)

        navigationItem.title = Localization.title.localized
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.setStatusBarStyle(from: themeColors.statusBarOnNavigation)
    }
}
extension EnterPhoneAuthController: MaskedTextFieldDelegateListener {

    open func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {

        self.competeInput = complete
    }
}
extension EnterPhoneAuthController {
    @IBAction private func sendCode() {

        closeKeyboard()

        if (!competeInput) {
            showToast(Localization.alertsNotCorrectPhone)
            return
        }

        guard let phone = phoneField.text else {
            return
        }

        interfaceLoader.show()
        let provider = PhoneAuthProvider.provider()
        provider.verifyPhoneNumber(phone, uiDelegate: nil) { (verificationId, error) in
            DispatchQueue.main.async {

                self.interfaceLoader.hide()

                if let error = error {
                    Log.warning(self._tag, "Problem with verificate phone number")
                    print(error.localizedDescription)

                    self.showToast(Localization.alertsVerificationProblem)
                    return
                }

                guard let verificationId = verificationId else {
                    return
                }

                Log.debug(self._tag, "Verification Id: \(verificationId)")
                
                let checkController = CheckPhoneCodeAuthController(for: verificationId, with: self.handler)
                self.navigationController?.pushViewController(checkController, animated: true)
            }
        }
    }
    @IBAction private func closeKeyboard() {
        view.endEditing(true)
    }
}
extension EnterPhoneAuthController {
    internal enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(EnterPhoneAuthController.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        case title = "Title"

        case labelsEnterPhone = "Labels.EnterPhone"

        case fieldsPhonePlacesholder = "Fields.Phone.Placeholder"

        case buttonsSendCode = "Buttons.SendCode"

        case alertsNotCorrectPhone = "Alerts.NotCorrectPhone"
        case alertsVerificationProblem = "Alerts.VerificationProblem"
    }
}
