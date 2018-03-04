//
//  StartController.swift
//  Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit
import CoreTools
import UITools
import UIElements
import UIServices

public class GreetingController: UIViewController {

    //UI
    @IBOutlet weak var DemoButton: UIButton!

    private let colorsTheme = DependencyResolver.resolve(ThemeColors.self)
    private let fontsTheme = DependencyResolver.resolve(ThemeFonts.self)

    //Services
    private let auth = DependencyResolver.resolve(AuthUIService.self)
    private let keys = DependencyResolver.resolve(ApiKeyService.self)

    public init() {
        super.init(nibName: "GreetingControllerView", bundle: Bundle.main)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (keys.isAuth) {
            goWithoutAuth()
            return
        }

        self.navigationController?.setNavigationBarHidden(true, animated: animated)

        //Demo button
        DemoButton.tintColor = colorsTheme.contentBackgroundText
        DemoButton.titleLabel?.font = fontsTheme.default(size: .caption)
    }

    // MARK: Auth navigation
    @IBAction func goToSignUp(_ sender: Any) {
        goToAuth()
    }
    @IBAction func goToLogin(_ sender: Any) {
        goToAuth()
    }
    private func goToAuth() {
        self.show(auth)
    }

    @IBAction func goWithoutAuth() {
        goBack()
    }
    private func goBack() {
        self.navigationController?.popViewController(animated: false)
    }
}
