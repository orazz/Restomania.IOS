//
//  ForgetPasswordController.swift
//  Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit

public class  ForgetPasswordController: BaseAuthController {

    //UI
    @IBOutlet public weak var ResetPaaswordButton: UIButton!
    @IBOutlet public weak var ToAuthButton: UIButton!

    //Theme
    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    public init() {
        super.init(nibName: String.tag(ForgetPasswordController.self), bundle: Bundle.coreFramework)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        ToAuthButton.tintColor = themeColors.actionMain
        ToAuthButton.titleLabel?.font = themeFonts.default(size: .subhead)
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

                    self.showAlert(about: EmailAuth.Localization.alertSendResetPassword.localized,
                                   title: EmailAuth.Localization.alertsSuccessTitle.localized)
//                    self.root.moveTo(.login)

                    return
                }

                //Process errors
                let title = EmailAuth.Localization.alertsResetPasswordTitle.localized
                if (response.statusCode == .ConnectionError) {
                    self.showAlert(about: EmailAuth.Localization.alertsNoConnection.localized, title: title)

                } else if (response.statusCode == .NotFound) {
                    self.showAlert(about: EmailAuth.Localization.alertsNotFoundByEmail.localized, title: title)

                } else {
                    self.showAlert(about: EmailAuth.Localization.alertsPromlemOnServer.localized, title: title)
                }
            }
        })
    }
    @IBAction public func returnToAuthAction() {
//        root.moveTo(.login)
    }
}
