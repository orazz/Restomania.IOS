//
//  SignupController.swift
//  Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import Foundation
import MdsKit
import CoreTools
import UITools
import UIElements

public class SignupController: BaseAuthController {

    //UI
    @IBOutlet private weak var Signup: DefaultButton!
    @IBOutlet private weak var Login: InvertedButton!
    @IBOutlet private weak var ForgetPassword: UIButton!

    //Theme
    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)


    public init() {
        super.init(nibName: String.tag(SignupController.self), bundle: Bundle.uiServices)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
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
//                    self.root!.close()

                    return
                }

                //Process errors
                let title = EmailAuth.Localization.alertsAuthTitle.localized
                if (response.statusCode == .ConnectionError) {
                    self.showAlert(about: EmailAuth.Localization.alertsNoConnection.localized, title: title)
                    
                } else if (response.statusCode == .BadRequest) {
                    self.showAlert(about: EmailAuth.Localization.alertsSameEmail.localized, title: title)

                } else {
                    self.showAlert(about: EmailAuth.Localization.alertsPromlemOnServer.localized, title: title)
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
//                    self.root!.close()

                    return
                }

                //Process errors
                let title = EmailAuth.Localization.alertsAuthTitle.localized
                if (response.statusCode == .ConnectionError) {
                    self.showAlert(about: EmailAuth.Localization.alertsNoConnection.localized, title: title)

                } else if (response.statusCode == .Forbidden) {
                    self.showAlert(about: EmailAuth.Localization.alertsNotValid.localized, title: title)

                } else {
                    self.showAlert(about: EmailAuth.Localization.alertsPromlemOnServer.localized, title: title)
                }
            }
        })
    }

    @IBAction public func forgetPasswordAction() {
//        root?.moveTo(.forgetPassword)
    }
}
