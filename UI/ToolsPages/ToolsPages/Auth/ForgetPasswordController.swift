//
//  ForgetPasswordController.swift
//  Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit

public class  ForgetPasswordController: BaseAuthController {

    public static let nibName = "ForgetPasswordPage"

    @IBOutlet public weak var ResetPaaswordButton: UIButton!
    @IBOutlet public weak var ToAuthButton: UIButton!

    public override func viewDidLoad() {
        super.viewDidLoad()

        ToAuthButton.tintColor = ThemeSettings.Colors.main
        ToAuthButton.titleLabel?.font = ThemeSettings.Fonts.default(size: .subhead)
    }

    @IBAction public func resetPasswordAction() {

        if (!isValidLogin()) {
            return
        }

        loader.show()

        let container = authContainer
        let task = client.RecoverPassword(email: container.login, role: configs.appUserRole)
        task.async(.background, completion: { response in

            DispatchQueue.main.async {

                self.loader.hide()

                //Success result
                if (response.isSuccess) {

                    self.showAlert(about: NSLocalizedString("Your new password send to you via your connection method.", comment: "Auth"),
                                   title: NSLocalizedString("Success", comment: "Auth"))
                    self.root.moveTo(.login)

                    return
                }

                //Process errors
                let title = NSLocalizedString("Reset password error", comment: "Auth")
                if (response.statusCode == .ConnectionError) {
                    self.showAlert(about: NSLocalizedString("No internet connection.", comment: "Network"), title: title)

                } else if (response.statusCode == .NotFound) {
                    self.showAlert(about: NSLocalizedString("User with same email not found.", comment: "Auth"), title: title)

                } else {
                    self.showAlert(about: NSLocalizedString("Try recovery password later.", comment: "Auth"), title: title)
                }
            }
        })
    }
    @IBAction public func returnToAuthAction() {
        root.moveTo(.login)
    }
}
