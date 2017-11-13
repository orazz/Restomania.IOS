//
//  ProfileController.swift
//  FindMe
//
//  Created by Алексей on 19.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class ProfileController: UIViewController {

    //MARK: UI elements
    @IBOutlet public weak var avatarImage: ImageWrapper!
    @IBOutlet public weak var nameField: FMTextField!
    @IBOutlet public weak var sexSegment: FMSegmentedControl!
    @IBOutlet public weak var ageField: FMTextField!
    @IBOutlet public weak var acquaintancesStatusSwitch: FMSwitch!
    private var _loader: InterfaceLoader!
    private var _fieldsStorage: UIViewController.TextFieldsStorage?



    //MARK: Data & services
    private let _tag = String.tag(ProfileController.self)
    private var _keysStorage: IKeysStorage!
    private var _authApiService: UsersAuthApiService!
    private var _usersApiService: UsersMainApiService!
    private var _isInitUI: Bool = false



    //MARK: Life circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        let factory = ServicesFactory.shared
        _keysStorage = factory.keys
        _authApiService = ApiServices.Users.auth
        _usersApiService = ApiServices.Users.main
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.view.backgroundColor = ThemeSettings.Colors.background
        self.subscribeToScrollWhenKeyboardShow()
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        _fieldsStorage = self.closeKeyboardWhenTapOnRootView()
        setup()
        loadData()
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.unsubscribefromScrollWhenKeyboardShow()
    }
    private func setup() {

        if (_isInitUI) {
            return
        }
        _isInitUI = true

        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = avatarImage.frame.width / 2
        avatarImage.layer.borderColor = ThemeSettings.Colors.main.cgColor
        avatarImage.layer.borderWidth = 3.0

        nameField.title = "Ваше имя"
        sexSegment.title = "Кто вы?"
        sexSegment.values = [
            ("Девушка", UserSex.female),
            ("Парень", UserSex.male)
        ]
        ageField.title = "Сколько вам лет"
        ageField.valueType = .number
        acquaintancesStatusSwitch.title = "Заинтересованы во встречах?"

        _loader = InterfaceLoader(for: self.view)



        //Changes
        nameField.onCompleteChangeEvent = changeName(_:value:)
        sexSegment.onChangeEvent = changeSex(_:index:value:)
        ageField.onCompleteChangeEvent = changeAge(_:value:)
        acquaintancesStatusSwitch.onChangeEvent = changeStatus(_:value:)
    }
    private func loadData() {

        _loader.show()

        let request = _usersApiService.find()
        request.async(.background, completion: { response in

            DispatchQueue.main.async {

                self._loader.hide()

                if (response.isFail) {

                    let alert = UIAlertController(title: "Ошибка", message: "Возникла ошибка при обновлении данных. Проверьте подключение к интернету или повторите позднее.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: false, completion: nil)
                }
                else {

                    let account = response.data!
                    self.apply(account: account)
                }
            }
        })
    }
    private func apply(account: User) {

        avatarImage.setup(url: account.image)
        nameField.text = account.name
        sexSegment.select(account.sex)
        ageField.text = "\(account.age)"
        acquaintancesStatusSwitch.value = account.status == .readyForAcquaintance
    }



    //MARK: Change profile
    public func changeName(_ textField: UITextField, value: String?) {

        if (String.isNullOrEmpty(value)) {
            return
        }

        sendChanges(PartialUpdateContainer(property: Account.Keys.name, update: value!))
    }
    public func changeSex(_ segment: UISegmentedControl, index: Int, value: Any ) {

        sendChanges(PartialUpdateContainer(property: User.Keys.sex, update: (value as! UserSex).rawValue))
    }
    public func changeAge(_ textField: UITextField, value: String?) {

        if (String.isNullOrEmpty(value)) {
            return
        }

        sendChanges(PartialUpdateContainer(property: User.Keys.age, update: value!))
    }
    public func changeStatus(_ switch: UISwitch, value: Bool) {

        let newStatus = value ? UserStatus.readyForAcquaintance : UserStatus.hidden
        sendChanges(PartialUpdateContainer(property: User.Keys.status, update: newStatus.rawValue))
    }
    private func sendChanges(_ update: PartialUpdateContainer) {

        let request = _usersApiService.change(updates: [update])
        request.async(.background, completion: { response in

            if (response.isFail) {

                Log.Warning(self._tag, "Problem with update profile. Try update 'User.\(update.property)' on '\(update.update)'")
            }
        })
    }
}


