//
//  SignupController.swift
//  Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import Foundation
import CoreTools
import UITools
import UIElements

public class SignupController: BaseAuthController {

    public static let nibName = "SignupPage"

    //UI
    @IBOutlet private weak var Signup: BlackButton!
    @IBOutlet private weak var Login: WhiteButton!
    @IBOutlet private weak var ForgetPassword: UIButton!

    //Theme
    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    override public func viewDidLoad() {
        super.viewDidLoad()

        ForgetPassword.tintColor = themeColors.actionMain
        ForgetPassword.backgroundColor = themeColors.actionContent
        ForgetPassword.titleLabel?.font = themeFonts.default(size: .subhead)
    }

    //Sign up
    @IBAction public func signUpAction() {

        if (!isValidLogin() || !isValidPassword()) {
            return
        }

        loader.show()

        let container = authContainer
        let task = client.SignUp(email: container.login, password: container.password, role: configs.appUserRole)
        task.async(.background, completion: { response in

            DispatchQueue.main.async {

                self.loader.hide()

                //Success result
                if (response.isSuccess) {

                    self.keys.update(by: response.data!)
                    self.root!.close()

                    return
                }

                //Process errors
                let title = NSLocalizedString("Authorization error", comment: "Auth")
                if (response.statusCode == .ConnectionError) {

                    self.showAlert(about: NSLocalizedString("No internet connection.", comment: "Network"), title: title)
                } else if (response.statusCode == .BadRequest) {

                    self.showAlert(about: NSLocalizedString("Account with same email founded. Maybe you have an account?", comment: "Auth"), title: title)
                } else {

                    self.showAlert(about: NSLocalizedString("Try signup later.", comment: "Auth"), title: title)
                }
            }
        })
    }
    //Login
    @IBAction public func loginAction() {

//        root?.moveTo(.Login)
        unfocusControls()

        if (!isValidLogin() || !isValidPassword()) {
            return
        }

        loader.show()

        let container = authContainer
        let task = client.Login(email: container.login, password: container.password, role: configs.appUserRole)
        task.async(.background, completion: { response in

            DispatchQueue.main.async {

                self.loader.hide()

                //Success result
                if (response.isSuccess) {

                    self.keys.update(by: response.data!)
                    self.root!.close()

                    return
                }

                //Process errors
                let title = NSLocalizedString("Authorization error", comment: "Auth")
                if (response.statusCode == .ConnectionError) {

                    self.showAlert(about: NSLocalizedString("No internet connection.", comment: "Network"), title: title)
                } else if (response.statusCode == .Forbidden) {

                    self.showAlert(about: NSLocalizedString("Not valid login or password.", comment: "Auth"), title: title)
                } else {

                    self.showAlert(about: NSLocalizedString("Try login later.", comment: "Auth"), title: title)
                }
            }
        })
    }

    @IBAction public func forgetPasswordAction() {

        root?.moveTo(.forgetPassword)
    }
}
