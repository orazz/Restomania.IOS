//
//  BaseAuthController.swift
//  Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit

public class BaseAuthController: UIViewController {

    internal var root: AuthService!
    internal var client = ApiServices.Auth.main
    internal var storage = ToolsServices.shared.keys
    internal var loader: InterfaceLoader!

    private var login = String.empty
    private var password = String.empty
    private var rights = ApiRole.user

    @IBOutlet weak var Navbar: UINavigationBar!

    @IBOutlet weak var LoginTextField: UITextField?
    @IBOutlet weak var LoginLabel: UILabel?
    @IBOutlet weak var PasswordTextField: UITextField?
    @IBOutlet weak var PasswordLabel: UILabel?

    @IBAction public func cancelAuth() {

        root.close()
    }

    public var authContainer: AuthContainer {

        get {
            return AuthContainer(login: login, password: password, rights: rights)
        }
        set(update) {

            login = update.login
            password = update.password
            rights = update.role
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        loader = InterfaceLoader(for: self.view)

        LoginTextField?.addTarget(self, action: #selector(updateLogin), for: .editingChanged)
        PasswordTextField?.addTarget(self, action: #selector(updatePassword), for: .editingChanged)

        stylize()
    }
    @objc private func updateLogin() {
        login = LoginTextField?.text ?? String.empty
    }
    @objc private func updatePassword() {
        password = PasswordTextField?.text ?? String.empty
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        LoginTextField?.text = login
        PasswordTextField?.text = password
    }
    private func stylize() {

        view.backgroundColor = ThemeSettings.Colors.background

        let labelFont = ThemeSettings.Fonts.default(size: .head)
        let textFont = ThemeSettings.Fonts.default(size: .subhead)

        //Labels
        for label in [LoginLabel, PasswordLabel] {

            label?.font = labelFont
            label?.textColor = ThemeSettings.Colors.main
        }

        //Text fields
        for field in [LoginTextField, PasswordTextField] {

            field?.font = textFont
            field?.textColor = ThemeSettings.Colors.main
            field?.borderStyle = .none
        }

        //Navbar
        Navbar.backgroundColor = ThemeSettings.Colors.additional
    }

    internal func isValidLogin() -> Bool {

        let login = LoginTextField?.text ?? String.empty
        if (String.isNullOrEmpty(login)) {

            showAlert(about: NSLocalizedString("You should fill correct email.", comment: "Auth"),
                      title: NSLocalizedString("Error", comment: "Auth"))
            return false
        }

        return true
    }
    internal func isValidPassword() -> Bool {

        let password = PasswordTextField?.text ?? String.empty
        if (String.isNullOrEmpty(password)) {

            showAlert(about: NSLocalizedString("You should fill correct password.", comment: "Auth"),
                      title: NSLocalizedString("Error", comment: "Auth"))
            return false
        }

        return true
    }
    internal func showAlert(about message: String, title: String) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    internal func unfocusControls() {

        LoginTextField?.resignFirstResponder()
        PasswordTextField?.resignFirstResponder()
    }
}
