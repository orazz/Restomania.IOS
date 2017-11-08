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

        return nil != _keysStorage.keys(for: .User)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        _authService = AuthService(open: .signup, with: self.navigationController!, rights: .User)
        _keysStorage = ServicesManager.shared.keysStorage
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

        view.backgroundColor = ThemeSettings.Colors.background
    }

    @IBAction public func Logout() {

        _keysStorage.logout(for: .User)
        LogoutButton.isHidden = true
    }

    // MARK: Navigate to sub managers screens
    @IBAction public func goToEditProfile() {
        presentSubmanager(controller: ManagerEditProfileController())
    }
    @IBAction public func goToEditNotificationPreferences() {
        presentSubmanager(controller: ManagerEditNotificationPreferencesController())
    }
    @IBAction public func goToChangePassword() {
        presentSubmanager(controller: ChangePasswordController())
    }
    @IBAction public func goToPaymentCards() {
        presentSubmanager(controller: PaymentCardsController())
    }
    @IBAction public func goToOrders() {
        presentSubmanager(controller: ManagerOrdersController())
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