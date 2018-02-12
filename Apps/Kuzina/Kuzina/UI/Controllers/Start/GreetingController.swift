//
//  StartController.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit

public class GreetingController: UIViewController {

    @IBOutlet weak var DemoButton: UIButton!

    public init() {
        super.init(nibName: "GreetingControllerView", bundle: Bundle.main)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.hideNavigationBar()

        //Demo button
        DemoButton.tintColor = ThemeSettings.Colors.main
        DemoButton.titleLabel?.font = ThemeSettings.Fonts.default(size: .caption)
    }

    // MARK: Auth navigation
    @IBAction func goToSignUp(_ sender: Any) {
        goToAuth(page: .signup)
    }
    @IBAction func goToLogin(_ sender: Any) {
//        goToAuth(page: .login)
        goToAuth(page: .signup)
    }
    private func goToAuth(page: AuthPage) {
        let auth = AuthService(open: .signup, with: self.navigationController!, rights: .user)
        auth.show(complete: { success in
                if (success) {
                    self.goBack()
                }
            })
    }

    @IBAction func goWithoutAuth(_ sender: Any) {
        goBack()
    }
    private func goBack() {
        self.navigationController?.popViewController(animated: false)
    }
}
