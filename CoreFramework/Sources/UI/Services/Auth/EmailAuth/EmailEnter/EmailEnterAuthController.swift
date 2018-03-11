//
//  SignupController.swift
//  Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

internal class EmailEnterAuthController: UIViewController {

    //UI
    @IBOutlet private weak var enterEmailLabel: UILabel!
    @IBOutlet private weak var resetPasswordLabel: UILabel!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var signupButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    private var interfaceLoader: InterfaceLoader!

    //Services
    private let authApi = DependencyResolver.resolve(AuthMainApiService.self)
    private let configs = DependencyResolver.resolve(ConfigsContainer.self)
    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    //Data
    private let _tag = String.tag(EmailEnterAuthController.self)
    private let handler: AuthHandler
    private let loadQueue: AsyncQueue

    internal init(_ handler: AuthHandler) {

        self.handler = handler
        self.loadQueue = AsyncQueue.createForControllerLoad(for: _tag)

        super.init(nibName: String.tag(EmailEnterAuthController.self), bundle: Bundle.coreFramework)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    //Life circle
    public override func loadView() {
        super.loadView()

        interfaceLoader = InterfaceLoader(for: view)

        loadMarkup()
    }
    private func loadMarkup() {

        view.backgroundColor = themeColors.contentBackground

        enterEmailLabel.text = Localization.labelsEnterEmail.localized
        enterEmailLabel.font = themeFonts.default(size: .title)
        enterEmailLabel.textColor = themeColors.contentBackgroundText

        resetPasswordLabel.text = Localization.labelsResetPassword.localized
        resetPasswordLabel.font = themeFonts.default(size: .subhead)
        resetPasswordLabel.textColor = themeColors.contentBackgroundText


        emailField.placeholder = Localization.fieldsEmailPlaceholder.localized
        emailField.font = themeFonts.default(size: .head)
        emailField.textColor = themeColors.contentBackgroundText
        emailField.backgroundColor = themeColors.contentBackground

        passwordField.placeholder = Localization.fieldsPasswordPlaceholder.localized
        passwordField.font = themeFonts.default(size: .head)
        passwordField.textColor = themeColors.contentBackgroundText
        passwordField.backgroundColor = themeColors.contentBackground


        signupButton.setTitle(Localization.buttonsSignup.localized, for: .normal)
        loginButton.setTitle(Localization.buttonsLogin.localized, for: .normal)

        
        navigationItem.title = Localization.title.localized
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.setStatusBarStyle(from: themeColors.statusBarOnNavigation)
    }
}
extension EmailEnterAuthController {

    @IBAction private func signUp() {

        closeKeyboard()

        guard let email = validateEmail(),
            let password = validatePassword() else {
                return
        }

        interfaceLoader.show()

        let request = authApi.signup(email: email, password: password, role: configs.appUserRole)
        request.async(loadQueue, completion: { response in
            DispatchQueue.main.async {

                self.interfaceLoader.hide()

                if (response.isFail) {

                    if (response.statusCode == .BadRequest) {
                        self.showToast(Localization.alertsExistUserWithSameEmail)
                    }
                    else {
                        self.alert(about: response)
                    }
                    return
                }

                let keys = response.data!
                self.handler.complete(success: true, keys: keys)
            }
        })
    }
    @IBAction private func login() {

        closeKeyboard()

        guard let email = validateEmail(),
            let password = validatePassword() else {
                return
        }

        interfaceLoader.show()

        let request = authApi.login(email: email, password: password, role: configs.appUserRole)
        request.async(loadQueue, completion: { response in
            DispatchQueue.main.async {

                self.interfaceLoader.hide()

                if (response.isFail) {

                    if (response.statusCode == .Forbidden) {
                        self.showToast(Localization.alertsWrongEmailorPassword)
                    }
                    else {
                        self.alert(about: response)
                    }
                    return
                }

                let keys = response.data!
                self.handler.complete(success: true, keys: keys)
            }
        })
    }
    @IBAction private func resetPassword() {
        closeKeyboard()

        let email = emailField.text ?? String.empty
        let vc = ResetPasswordAuthController(for: email)
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction private func closeKeyboard() {
        view.endEditing(true)
    }

    internal func validateEmail() -> String? {
        return validateEmail(emailField)
    }
    internal func validatePassword() -> String? {

        let password = passwordField.text ?? String.empty
        if (String.isNullOrEmpty(password)) {

            showToast(Localization.alertsNotCorrectPassword)
            return nil
        }

        return password
    }
}
extension UIViewController {
    internal func validateEmail(_ field: UITextField) -> String? {

        let email = field.text ?? String.empty
        if (String.isNullOrEmpty(email)) {

            showToast(EmailEnterAuthController.Localization.alertsNotCorrectEmail)
            return nil
        }

        return email
    }
}
extension EmailEnterAuthController {
    internal enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(EmailEnterAuthController.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        case title = "Title"

        case labelsEnterEmail = "Labels.EnterEmail"
        case labelsResetPassword = "Labels.ResetPassword"

        case fieldsEmailPlaceholder = "Fields.Email.Placeholder"
        case fieldsPasswordPlaceholder = "Fields.Password.Placeholder"

        case buttonsSignup = "Buttons.Signup"
        case buttonsLogin = "Buttons.Login"

        case alertsNotCorrectEmail = "Alerts.NotCorrectEmail"
        case alertsNotCorrectPassword = "Alerts.NotCorrectPassword"
        case alertsWrongEmailorPassword = "Alerts.WrongEmailorPassword"
        case alertsExistUserWithSameEmail = "Alerts.ExistUserWithSameEmail"
    }
}
