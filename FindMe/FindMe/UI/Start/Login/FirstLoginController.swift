//
//  FirstLoginController.swift
//  FindMe
//
//  Created by Алексей on 02.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import AsyncTask
import IOSLibrary

public class FirstLoginController: UIViewController {

    private static let nibName = "FirstLoginController"
    public static var instance: FirstLoginController {

        let instance = FirstLoginController(nibName: nibName, bundle: Bundle.main)

        instance.keysStorage = ToolsServices.shared.keys
        instance.authApiService = ApiServices.Users.auth
        instance.usersApiService = ApiServices.Users.main

        return instance
    }

    //MARK: UIElements
    @IBOutlet public weak var nameTextField: FMTextField!
    @IBOutlet public weak var sexSegmentControl: FMSegmentedControl!
    @IBOutlet public weak var ageTextField: FMTextField!
    @IBOutlet public weak var acquaintancesStatusSwitch: FMSwitch!

    @IBOutlet public weak var firstDividerView:UIView!
    @IBOutlet public weak var secondDividerView:UIView!

    @IBOutlet public weak var vkButton: UIButton!
    private var loader: InterfaceLoader!



    //MARK: Data & Services
    private let _tag = String.tag(FirstLoginController.self)
    private var keysStorage: IKeysStorage!
    private var authApiService: UsersAuthApiService!
    private var usersApiService: UsersMainApiService!
    private var fieldsStorage: UIViewController.TextFieldsStorage?



    //MARK: Controller circle
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setToolbarHidden(true, animated: false)
        self.subscribeToScrollWhenKeyboardShow()
    }
    public override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        fieldsStorage = self.closeKeyboardWhenTapOnRootView()
        initMarkup()
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.unsubscribefromScrollWhenKeyboardShow()
    }
    private func initMarkup() {

        self.view.backgroundColor = ThemeSettings.Colors.background 

        nameTextField.title = "Ваше имя"
        sexSegmentControl.title = "Кто вы?"
        sexSegmentControl.values = [
            ("Девушка", UserSex.female),
            ("Парень", UserSex.male)
        ]
        ageTextField.title = "Сколько вам лет"
        ageTextField.text = "21"
        ageTextField.valueType = .number
        acquaintancesStatusSwitch.title = "Заинтересованы во встречах?"

        firstDividerView.backgroundColor = ThemeSettings.Colors.divider
        secondDividerView.backgroundColor = ThemeSettings.Colors.divider

        vkButton.backgroundColor = ThemeSettings.Colors.vk
        vkButton.layer.borderColor = ThemeSettings.Colors.vk.cgColor
        vkButton.titleLabel?.textColor = ThemeSettings.Colors.whiteText
        let icon = UIImageView(frame: CGRect(x: 5, y: 5, width: 40, height: 40))
        icon.image = ThemeSettings.Images.vkLogo
        vkButton.addSubview(icon)

        loader = InterfaceLoader(for: self.view)
    }



    //MARK: Actions
    @IBAction public func continueWithoutAuth() {

        loader.show()

        let request = authApiService.anonymous()
        request.async(.background, completion: { response in

            if (response.isSuccess) {

                self.keysStorage.set(for: .user, keys: response.data!)

                let updates = PartialUpdateContainer.collect([
                    Account.Keys.name: self.nameTextField.text,
                    User.Keys.sex: (self.sexSegmentControl.value as! UserSex).rawValue,
                    User.Keys.age: self.ageTextField.text ?? "21",
                    User.Keys.status: (self.acquaintancesStatusSwitch.value ? UserStatus.readyForAcquaintance : UserStatus.hidden).rawValue
                    ])

                let changeRequest = self.usersApiService.change(updates: updates)
                changeRequest.async(.background, completion: { response in

                    if (response.isFail) {

                        Log.Warning(self._tag, "Problem with udpate user profile.")
                    }
                })
            }

            DispatchQueue.main.async {

                self.loader.hide()

                if (!response.isSuccess) {
                    self.showAlertProblemWithAuth()
                }
                else {
                    self.goBack()
                }
            }
        })

    }
    @IBAction public func authViaVk() {

        let service = VKAuthorizationController.build(callback: { success, result in

            if (success) {
                self.goBack()
                LogicServices.shared.likes.takeFromRemote()
            }
            else {
                self.showAlertProblemWithAuth()
            }
        })
        self.navigationController?.present(service, animated: true, completion: nil)
    }
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    private func showAlertProblemWithAuth() {

        let alert = UIAlertController(title: "Ошибка", message: "Проблемы с авторизацией пользователя. Проверьте подключение к интернету.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
}