//
//  SelecAuthController.swift
//  UIServices
//
//  Created by Алексей on 10.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

internal class SelectAuthController: UIViewController {

    //UI
    @IBOutlet weak var titlePanel: UINavigationItem!
    @IBOutlet weak var cancelAction: UIBarButtonItem!

    @IBOutlet weak var enterViaLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var leftDivider: UIView!
    @IBOutlet weak var rightDivider: UIView!
    @IBOutlet weak var acceptTermsLabel: UILabel!

    @IBOutlet weak var vkButton: DefaultButton!
    @IBOutlet weak var instagramButton: DefaultButton!
    @IBOutlet weak var phoneButton: DefaultButton!
    @IBOutlet weak var emailButton: InvertedButton!
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return themeColors.defaultStatusBar
    }

    //Service
    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)
    private let handler: AuthHandler


    internal init(for handler: AuthHandler) {

        self.handler = handler

        super.init(nibName: String.tag(SelectAuthController.self), bundle: Bundle.coreFramework)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    //Life circle
    public override func loadView() {
        super.loadView()

        loadMarkup()
    }
    private func loadMarkup() {

        view.backgroundColor = themeColors.contentBackground

        titlePanel.title = Localization.title.localized

        cancelAction.title = Localization.buttonsCancel.localized

        enterViaLabel.text = Localization.labelEnterVia.localized
        enterViaLabel.font = themeFonts.default(size: .title)
        enterViaLabel.textColor = themeColors.contentBackgroundText

        orLabel.text = Localization.labelOr.localized
        orLabel.font = themeFonts.default(size: .caption)
        orLabel.textColor = themeColors.contentBackgroundText

        leftDivider.backgroundColor = themeColors.contentBackgroundText
        rightDivider.backgroundColor = themeColors.contentBackgroundText

        acceptTermsLabel.text = Localization.labelAcceptTerms.localized
        acceptTermsLabel.font = themeFonts.default(size: .subcaption)
        acceptTermsLabel.textColor = themeColors.contentBackgroundText



//      Buttons
//      VK
        vkButton.setTitle(Localization.buttonsVk.localized, for: .normal)
        vkButton.titleLabel?.textColor = UIColor.white
        vkButton.backgroundColor = themeColors.vkColor
        vkButton.layer.borderColor = themeColors.vkColor.cgColor

//      Instagram
        instagramButton.setTitle(Localization.buttonsInstagram.localized, for: .normal)
        instagramButton.titleLabel?.textColor = UIColor.white
        instagramButton.backgroundColor = themeColors.instagramColor
        instagramButton.layer.borderColor = themeColors.instagramColor.cgColor

//      Phone
        phoneButton.setTitle(Localization.buttonsPhone.localized, for: .normal)

//      Email
        emailButton.setTitle(Localization.buttonsEmail.localized, for: .normal)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
extension SelectAuthController {
    @IBAction private func enterViaVk() {

        let vk = VkAuthController(handler)
        navigationController?.pushViewController(vk, animated: true)
    }
    @IBAction private func enterViaInstagram() {

        let instagram = InstagramAuthController(handler)
        navigationController?.pushViewController(instagram, animated: true)
    }
    @IBAction private func enterViaPhone() {

        let phone = EnterPhoneController(handler)
        navigationController?.pushViewController(phone, animated: true)
    }
    @IBAction private func enterViaEmail() {

    }
    @IBAction private func lookTerms() {

        let terms = TermsController()
        navigationController?.pushViewController(terms, animated: true)
    }
    @IBAction private func cancelAuth() {

        handler.complete(success: false, keys: nil)
    }
}
extension SelectAuthController {
    internal enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(SelectAuthController.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }


        case title = "Title"

        case labelEnterVia = "Labels.EnterVia"
        case labelOr = "Labels.Or"
        case labelAcceptTerms = "Lebels.AcceptTerms"

        case buttonsCancel = "Buttons.Cancel"
        case buttonsVk = "Buttons.Vk"
        case buttonsInstagram = "Buttons.Instagram"
        case buttonsPhone = "Buttons.Phone"
        case buttonsEmail = "Buttons.Email"
    }
}
