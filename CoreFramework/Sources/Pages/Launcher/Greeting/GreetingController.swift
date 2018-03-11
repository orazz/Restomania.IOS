//
//  StartController.swift
//  Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit 

public class GreetingController: UIViewController {

    //UI
    @IBOutlet private weak var logo: UIImageView!
    @IBOutlet weak var EnterButton: UIButton!
    @IBOutlet weak var DemoButton: UIButton!
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return colorsTheme.statusBarOnContent
    }

    private let colorsTheme = DependencyResolver.resolve(ThemeColors.self)
    private let fontsTheme = DependencyResolver.resolve(ThemeFonts.self)
    private let themeImages = DependencyResolver.resolve(ThemeImages.self)

    //Services
    private let auth = DependencyResolver.resolve(AuthUIService.self)
    private let keys = DependencyResolver.resolve(ApiKeyService.self)

    public var onCompleteHandler: Trigger?

    public init() {
        super.init(nibName: String.tag(GreetingController.self), bundle: Bundle.coreFramework)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    public override func loadView() {
        super.loadView()

        view.backgroundColor = colorsTheme.contentBackground

        logo.image = themeImages.toolsLogo

        EnterButton.titleLabel?.text = Localization.buttonsEnter.localized

        DemoButton.tintColor = colorsTheme.contentBackgroundText
        DemoButton.titleLabel?.font = fontsTheme.default(size: .caption)
        DemoButton.titleLabel?.text = Localization.buttonsDemo.localized
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: Auth navigation
    @IBAction func goToSignUp(_ sender: Any) {
        goToAuth()
    }
    @IBAction func goToLogin(_ sender: Any) {
        goToAuth()
    }
    private func goToAuth() {
        self.showAuth(complete: { success, _ in
            if (success) {
                self.complete()
            }
        })
    }

    @IBAction func goWithoutAuth() {
        complete()
    }
    private func complete() {
        onCompleteHandler?()
    }
}
extension GreetingController: LaunchControllerDelegate {
    public var notNeedDisplay: Bool {
        return keys.isAuth
    }

    public func hiddenProcessing() {}
}

extension GreetingController {
    public enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(GreetingController.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        //Buttons
        case buttonsEnter = "Buttons.Enter"
        case buttonsDemo = "Buttons.Demo"
    }
}
