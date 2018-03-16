//
//  ResetPasswordAuthController.swift
//  CoreFramework
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//
import Foundation
import UIKit
import MdsKit

internal class ResetPasswordAuthController: UIViewController {

    //UI
    @IBOutlet private weak var resetPasswordLabel: UILabel!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var resetPasswordButton: UIButton!
    private var interfaceLoader: InterfaceLoader!

    //Services
    private let authApi = DependencyResolver.resolve(AuthMainApiService.self)
    private let configs = DependencyResolver.resolve(ConfigsContainer.self)
    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    //Data
    private let _tag = String.tag(ResetPasswordAuthController.self)
    private let loadQueue: AsyncQueue
    private let storedEmail: String

    internal init(for email: String) {

        self.loadQueue = AsyncQueue.createForControllerLoad(for: _tag)
        self.storedEmail = email

        super.init(nibName: String.tag(ResetPasswordAuthController.self), bundle: Bundle.coreFramework)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //Life circle
    public override func loadView() {
        super.loadView()

        interfaceLoader = InterfaceLoader(for: view)

        loadMarkup()
    }
    private func loadMarkup() {

        view.backgroundColor = themeColors.contentBackground

        resetPasswordLabel.text = Localization.labelsResetPassword.localized
        resetPasswordLabel.font = themeFonts.default(size: .title)
        resetPasswordLabel.textColor = themeColors.contentBackgroundText

        emailField.font = themeFonts.default(size: .head)
        emailField.textColor = themeColors.contentBackgroundText
        emailField.placeholder = Localization.fieldsEmailPlaceholder.localized
        emailField.text = storedEmail


        resetPasswordButton.setTitle(Localization.buttonsResetPassword.localized, for: .normal)


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
extension ResetPasswordAuthController {
    @IBAction private func resetPassword() {

        closeKeyboard()

        guard let email = validateEmail(emailField) else {
            return
        }

        interfaceLoader.show()

        let request = authApi.RecoverPassword(email: email, role: configs.appUserRole)
        request.async(loadQueue, completion: { response in
            DispatchQueue.main.async {

                self.interfaceLoader.hide()

                if (response.isFail) {

                    if (response.statusCode == .NotFound) {
                        self.showToast(Localization.alertsNotFoundUser)
                    }
                    else {
                        self.alert(about: response)
                    }
                    return
                }

                self.navigationController?.popViewController(animated: true)
                self.navigationController?.showToast(Localization.alertsResetPassword)
            }
        })
    }
    @IBAction private func closeKeyboard() {
        view.endEditing(true)
    }
}
extension ResetPasswordAuthController {
    internal enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(ResetPasswordAuthController.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        case title = "Title"

        case labelsResetPassword = "Labels.ResetPassword"

        case fieldsEmailPlaceholder = "Fields.Email.Placeholder"

        case buttonsResetPassword = "Buttons.ResetPassword"

        case alertsResetPassword = "Alerts.ResetPassword"
        case alertsNotFoundUser = "Alerts.NotFoundUser"
    }
}
