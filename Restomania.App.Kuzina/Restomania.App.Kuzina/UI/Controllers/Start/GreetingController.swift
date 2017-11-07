//
//  StartController.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import IOSLibrary

public class GreetingController: UIViewController {

    private let _tag = "StartController"

    @IBOutlet weak var DemoButton: UIButton!

    override public func viewDidLoad() {
        super.viewDidLoad()

        Log.Info(_tag, "Open controller.")
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let storage = ServicesManager.shared.keysStorage
        if let _ = storage.keys(for: .User) {

            goToSearch()
        }

        setupMarkup()
    }
    private func setupMarkup() {

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
        let auth = AuthService(open: .signup, with: self.navigationController!, rights: .User)
        auth.show(complete: { success in

                if (success) {

                    self.goToSearch()
                }
            })
    }

    @IBAction func goWithoutAuth(_ sender: Any) {
        goToSearch()
    }
    private func goToSearch() {

        let board = UIStoryboard(name: "Tabs", bundle: nil)
        let controller = board.instantiateInitialViewController()!

        navigationController?.present(controller, animated: false, completion: {

            Log.Debug(self._tag, "Navigate to tabs storyboard.")
        })
    }
}
