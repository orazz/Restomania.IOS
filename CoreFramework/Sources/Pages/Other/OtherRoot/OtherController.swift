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

    //UI
    @IBOutlet private weak var profiledButton: UIButton!
    @IBOutlet private weak var notificationstButton: UIButton!
    @IBOutlet private weak var paymentCardsButton: UIButton!
    @IBOutlet private weak var termsButton: UIButton!
    @IBOutlet private weak var logoutButton: UIButton!

    private let router = DependencyResolver.get(Router.self)
    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let keysService = DependencyResolver.get(ApiKeyService.self)

    //Data
    private let _tag = String.tag(OtherController.self)
    private let guid = Guid.new


    public init() {
        super.init(nibName: String.tag(OtherController.self), bundle: Bundle.coreFramework)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public override func loadView() {
        super.loadView()

        UIView.setAnimationsEnabled(false)

        profiledButton.setTitle(Localization.buttonProfile.localized, for: .normal)
        notificationstButton.setTitle(Localization.buttonNotifications.localized, for: .normal)
        paymentCardsButton.setTitle(Localization.buttonPaymentCards.localized, for: .normal)
        termsButton.setTitle(Localization.buttonTerms.localized, for: .normal)
        logoutButton.setTitle(Localization.buttonLogout.localized, for: .normal)

        view.layoutIfNeeded()
        UIView.setAnimationsEnabled(true)

        view.backgroundColor = themeColors.contentBackground
    }
    public override func viewDidLoad() {
        super.viewDidLoad()

        loadMarkup()

        keysService.subscribe(guid: guid, handler: self, tag: _tag)
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.view.layoutSubviews()
        self.navigationItem.title = Localization.title.localized
    }

    private func loadMarkup() {

        updateLogoutButton()
    }

    @IBAction public func Logout() {

        keysService.logout()
        updateLogoutButton()
    }
    private func updateLogoutButton() {
        DispatchQueue.main.async {
            self.logoutButton.isHidden = !self.keysService.isAuth
        }
    }

    // MARK: Navigate to sub managers screens
    @IBAction public func goToNotifications() {
        present(OtherNotificationController())
    }
    @IBAction public func goToProfile() {
        present(ManagerChangePasswordController.create())
    }
    @IBAction public func goToPaymentCards() {
        present(OtherPaymentCardsController())
    }
    @IBAction public func goToTerms() {
        present(TermsController(), needAuth: false)
    }
    private func present(_ controller: UIViewController, needAuth: Bool = true) {

        if (!needAuth || keysService.isAuth) {
            router.push(controller, animated: true)
            return
        }

        self.showAuth(complete: { success, _  in
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

        case title = "Title"
        case buttonProfile = "Buttons.Profile"
        case buttonNotifications = "Buttons.Notifications"
        case buttonPaymentCards = "Buttons.PaymentCards"
        case buttonTerms = "Buttons.Terms"
        case buttonLogout = "Buttons.Logout"
    }
}
extension OtherController: ApiKeyServiceDelegate {
    public func apiKeyService(_ service: ApiKeyService, update keys: ApiKeys, for role: ApiRole) {
        updateLogoutButton()
    }
    public func apiKeyService(_ service: ApiKeyService, logout role: ApiRole) {
        updateLogoutButton()
    }
}
