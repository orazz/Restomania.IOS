//
//  ManagerController.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 24.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import IOSLibrary

public class ManagerController: UIViewController {

    private let _tag = "ManagerController"

    //Elements
    @IBOutlet weak var LogoutButton: UIButton!

    private var _theme: ThemeSettings!
    private var _authService: AuthService!
    private var _keysStorage: IKeysStorage!

    //Properties
    private var _isAuth: Bool {

        return nil != _keysStorage.keysFor(rights: .User)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        _theme = AppSummary.current.theme
        _authService = AuthService(open: .signup, with: self.navigationController!, rights: .User)
        _keysStorage = ServicesManager.current.keysStorage
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        hideNavigationBar()

        setupIntefrace()
        setupStyles()
    }

    private func setupIntefrace() {

        LogoutButton.isHidden = !_isAuth

    }
    private func setupStyles() {

        let theme = AppSummary.current.theme

        view.backgroundColor = theme.backgroundColor
    }

    @IBAction public func Logout() {

        _keysStorage.logout(for: .User)
        LogoutButton.isHidden = true
    }

    // MARK: Navigate to sub managers screens
    @IBAction public func goToEditProfile() {
        presentSubmanager(controller: EditProfileController())
    }
    @IBAction public func goToEditNotificationPreferences() {
        presentSubmanager(controller: EditNotificationPreferencesController())
    }
    @IBAction public func goToChangePassword() {
        presentSubmanager(controller: ChangePasswordController())
    }
    @IBAction public func goToPaymentCards() {
        presentSubmanager(controller: PaymentCardsController())
    }
    @IBAction public func goToOrders() {
        presentSubmanager(controller: OrdersController())
    }
    @IBAction public func goToTerms() {
        presentSubmanager(controller: TermsController(), needAuth: false)
    }
    private func presentSubmanager(controller: UIViewController, needAuth: Bool = true) {

        if (!needAuth || _isAuth) {

            navigationController?.pushViewController(controller, animated: true)
        } else {

            _authService.show(complete: { success in

                if (success) {

                    self.presentSubmanager(controller: controller, needAuth: needAuth)
                }
            })
        }
    }
}
