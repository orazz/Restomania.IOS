//
//  OtherController.swift
//  CoreFramework
//
//  Created by Алексей on 24.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit 

public class OtherController: UIViewController {

    private let _tag = String.tag(OtherController.self)

    //UI
    @IBOutlet private weak var notificationstButton: UIButton!
    @IBOutlet private weak var changePasswordButton: UIButton!
    @IBOutlet private weak var paymentCardsButton: UIButton!
    @IBOutlet private weak var termsButton: UIButton!
    @IBOutlet private weak var logoutButton: UIButton!

    private let router = DependencyResolver.resolve(Router.self)
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

    public override func loadView() {
        super.loadView()

        UIView.setAnimationsEnabled(false)

        notificationstButton.setTitle(Localization.buttonNotifications.localized, for: .normal)
        changePasswordButton.setTitle(Localization.buttonChangePassword.localized, for: .normal)
        paymentCardsButton.setTitle(Localization.buttonPaymentCards.localized, for: .normal)
        termsButton.setTitle(Localization.buttonTerms.localized, for: .normal)
        logoutButton.setTitle(Localization.buttonLogout.localized, for: .normal)

        view.layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
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

        logoutButton.isHidden = !isAuth
    }

    @IBAction public func Logout() {

        keysService.logout()

        logoutButton.isHidden = true
    }

    // MARK: Navigate to sub managers screens
    @IBAction public func goToNotifications() {
        present(OtherNotificationController())
    }
    @IBAction public func goToChangePassword() {
        present(ManagerChangePasswordController.create())
    }
    @IBAction public func goToPaymentCards() {
        present(OtherPaymentCardsController())
    }
    @IBAction public func goToTerms() {
        present(TermsController(), needAuth: false)
    }
    private func present(_ controller: UIViewController, needAuth: Bool = true) {

        if (!needAuth || isAuth) {
            router.push(controller, animated: true)
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
extension OtherController {
    public enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(OtherController.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        case buttonNotifications = "Buttons.Notifications"
        case buttonChangePassword = "Buttons.ChangePassword"
        case buttonPaymentCards = "Buttons.PaymentCards"
        case buttonTerms = "Buttons.Terms"
        case buttonLogout = "Buttons.Logout"
    }
}
