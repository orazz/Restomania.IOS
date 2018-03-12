//
//  OtherController.swift
//  Kuzina
//
//  Created by Алексей on 24.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit 

public class OtherController: UIViewController {

    private let _tag = String.tag(OtherController.self)

    //UI
    @IBOutlet private weak var LogoutButton: UIButton!

    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let keysService = DependencyResolver.resolve(ApiKeyService.self)

    //Properties
    private var isAuth: Bool {
        return keysService.isAuth
    }


    public init() {
        super.init(nibName: String.tag(OtherController.self), bundle: Bundle.coreFramework)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        loadMarkup()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func loadMarkup() {

        view.backgroundColor = themeColors.contentBackground

        LogoutButton.isHidden = !isAuth
    }

    @IBAction public func Logout() {

        keysService.logout()
        LogoutButton.isHidden = true
    }

    // MARK: Navigate to sub managers screens
    @IBAction public func goToEditProfile() {
//        presentSubmanager(controller: ManagerEditProfileController())
    }
    @IBAction public func goToEditNotificationPreferences() {
//        presentSubmanager(controller: ManagerEditNotificationPreferencesController())
    }
    @IBAction public func goToChangePassword() {
        present(ManagerChangePasswordController.create())
    }
    @IBAction public func goToPaymentCards() {
        present(ManagerPaymentCardsController())
    }
    @IBAction public func goToOrders() {
        present(ManagerOrdersController())
    }
    @IBAction public func goToTerms() {
        present(TermsController(), needAuth: false)
    }
    private func present(_ controller: UIViewController, needAuth: Bool = true) {

        if (!needAuth || isAuth) {
            navigationController?.pushViewController(controller, animated: true)
            return
        }

        showAuth(complete: { success, _  in
            if (success) {
                
                DispatchQueue.main.async {
                    self.present(controller, needAuth: needAuth)
                }
            }
        })
    }
}
