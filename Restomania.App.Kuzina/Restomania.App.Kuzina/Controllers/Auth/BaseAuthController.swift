//
//  BaseAuthController.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import IOSLibrary

public class BaseAuthController: UIViewController {

    internal var root: AuthServiceController?
    internal var client: OpenAccountsApiService!
    internal var storage: IKeysCRUDStorage!
    private var login = String.Empty
    private var password = String.Empty
    private var rights = AccessRights.User

    @IBOutlet weak var Navbar: UINavigationBar!

    @IBOutlet weak var LoginTextField: UITextField!
    @IBOutlet weak var LoginLabel: UILabel!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var PasswordLabel: UILabel!

    public var authContainer: AuthContainer {

        return AuthContainer(login: login, password: password, rights: rights)
    }
    public func setup(_ container: AuthContainer) {

        login = container.login
        password = container.password
        rights = container.rights
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        client = OpenAccountsApiService()
        storage = ServicesManager.current.keysStorage as! IKeysCRUDStorage

        LoginTextField.addTarget(self, action: #selector(updateLogin), for: .editingChanged)
        PasswordTextField.addTarget(self, action: #selector(updatePassword), for: .editingChanged)

        stylize()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        LoginTextField.text = login
        PasswordTextField.text = password
    }
    @objc private func updateLogin() {

        login = LoginTextField.text ?? String.Empty
    }
    @objc private func updatePassword() {

        password = PasswordTextField.text ?? String.Empty
    }
    private func stylize() {

        let theme = AppSummary.current.theme

        view.backgroundColor = theme.backgroundColor

        let labelFont = UIFont(name: theme.susanBookFont, size: theme.headlineFontsize)
        let textFont = UIFont(name: theme.susanBookFont, size: theme.subheadFontSize)

        //Labels
        for label in [LoginLabel, PasswordLabel] {

            label?.font = labelFont
            label?.textColor = theme.blackColor
        }

        //Text fields
        for field in [LoginTextField, PasswordTextField] {

            field?.font = textFont
            field?.textColor = theme.blackColor
            field?.borderStyle = .none
        }

        //Navbar
        Navbar.backgroundColor = theme.whiteColor
    }

    internal func isValidLogin() -> Bool {

        let login = LoginTextField.text ?? String.Empty
        if (String.IsNullOrEmpty(login)) {

            showAlert(about: NSLocalizedString("You should fill correct email.", comment: "Auth"),
                      title: NSLocalizedString("Error", comment: "Auth"))
            return false
        }

        return true
    }
    internal func isValidPassword() -> Bool {

        let password = PasswordTextField.text ?? String.Empty
        if (String.IsNullOrEmpty(password)) {

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

        LoginTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
    }
}
