//
//  StartController.swift
//  CoreFramework
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
        return themeColors.statusBarOnContent
    }

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)
    private let themeImages = DependencyResolver.get(ThemeImages.self)

    //Services
    private let auth = DependencyResolver.get(AuthUIService.self)
    private let keys = DependencyResolver.get(ApiKeyService.self)

    public var onCompleteHandler: Trigger?

    public init() {
        super.init(nibName: String.tag(GreetingController.self), bundle: Bundle.coreFramework)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    public override func loadView() {
        super.loadView()

        view.backgroundColor = themeColors.contentBackground

        logo.image = themeImages.toolsLogo

        EnterButton.setTitle(Localization.buttonsEnter.localized, for: .normal)

        DemoButton.tintColor = themeColors.contentText
        DemoButton.titleLabel?.font = themeFonts.default(size: .caption)
        DemoButton.setTitle(Localization.buttonsDemo.localized, for: .normal)
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: Auth navigation
    @IBAction func goToAuth() {

        showAuth() { success, _ in
            if (success) {
                self.complete()
            }
        }
    }

    @IBAction func goWithoutAuth() {
        complete()
    }
    private func complete() {
        self.onCompleteHandler?()
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
