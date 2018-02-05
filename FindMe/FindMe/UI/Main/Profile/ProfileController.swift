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
import AsyncTask

public protocol ProfileControllerDelegate {

    func takeController() -> UIViewController

    func changeName(on value: String)
    func changeSex(on value: UserSex)
    func changeAge(on value: String)
    func changeStatus(on value: UserStatus)
    func changeAvatar(on image: UIImage?)

    func selectTowns()
}
public class ProfileController: UIViewController {

    //MARK: UI elements
    @IBOutlet public weak var avatarImage: AvatarImage!
    @IBOutlet public weak var nameField: FMTextField!
    @IBOutlet public weak var sexSegment: FMSegmentedControl!
    @IBOutlet public weak var ageField: FMTextField!
    @IBOutlet public weak var acquaintancesStatusSwitch: FMSwitch!
    private var loader: InterfaceLoader!
    private var fieldsStorage: UIViewController.TextFieldsStorage?


    //MARK: Data & services
    private let _tag = String.tag(ProfileController.self)
    private var account: User?
    private var loadQueue: AsyncQueue!
    private var apiQueue: AsyncQueue!
    private let accountApiService = ApiServices.Users.main



    //MARK: Life circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        loadQueue = AsyncQueue.createForControllerLoad(for: tag)
        apiQueue = AsyncQueue.createForApi(for: tag)

        loadMarkup()
        startLoadData()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.subscribeToScrollWhenKeyboardShow()
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.unsubscribefromScrollWhenKeyboardShow()
    }



    //MARK: Load data
    private func loadMarkup() {

        nameField.title = "Ваше имя"
        nameField.onCompleteChangeEvent =  { self.changeName(on: $1 ?? String.empty) }

        sexSegment.title = "Кто вы?"
        sexSegment.values = [
            ("Девушка", UserSex.female),
            ("Парень", UserSex.male)
        ]
        sexSegment.onChangeEvent = { self.changeSex(on: ($2 as? UserSex) ?? .unknown) }

        ageField.title = "Сколько вам лет"
        ageField.valueType = .number
        ageField.onCompleteChangeEvent = { self.changeAge(on: $1 ?? String.empty) }

        acquaintancesStatusSwitch.title = "Заинтересованы во встречах?"
        acquaintancesStatusSwitch.onChangeEvent = { self.changeStatus(on:  $1 ? .readyForAcquaintance : .hidden) }


        loader = InterfaceLoader(for: self.view)

        self.view.backgroundColor = ThemeSettings.Colors.background
        self.fieldsStorage = self.closeKeyboardWhenTapOnRootView()
    }
    private func startLoadData() {

        loader.show()

        loadData()
    }
    @objc private func refreshData() {
        loadData()
    }
    private func loadData() {

        let request = accountApiService.find()
        request.async(loadQueue, completion: { response in
            DispatchQueue.main.async {

                if (response.isFail) {
                    self.present(ProblemAlerts.Error(for: response.statusCode), animated: true, completion: nil)
                }

                self.completeLoad(response.data)
            }
        })
    }
    private func completeLoad(_ account: User?) {

        self.loader.hide()

        self.account = account
        if let account = account {
            apply(account: account)
        }
    }
    private func apply(account: User) {

        avatarImage.setup(url: account.image)
        nameField.text = account.name
        sexSegment.select(account.sex)
        ageField.text = "\(account.age)"
        acquaintancesStatusSwitch.value = account.status == .readyForAcquaintance
    }
}

extension ProfileController: ProfileControllerDelegate {
    
    public func takeController() -> UIViewController {
        return self
    }

    public func changeName(on value: String) {

        if (String.isNullOrEmpty(value)) {
            return
        }

        change(Account.Keys.name, on: value)
    }
    public func changeSex(on value: UserSex) {
        change(User.Keys.sex, on: value.rawValue)
    }
    public func changeAge(on value: String) {

        if (String.isNullOrEmpty(value)) {
            return
        }

        change(User.Keys.age, on: value)
    }
    public func changeStatus(on value: UserStatus) {
        change(User.Keys.status, on: value.rawValue)
    }
    private func change(_ property: String, on value: Any) {

        let update = PartialUpdateContainer(property: property, update: value)
        let request = accountApiService.change(updates: [update])
        request.async(apiQueue, completion: { response in
            DispatchQueue.main.async {
                if (response.isFail) {

                    Log.warning(self._tag, "Problem with update profile. Try update 'User.\(update.property)' on '\(update.update)'")
                    self.present(ProblemAlerts.NotConnection, animated: true, completion: nil)
                }
            }
        })
    }
    public func changeAvatar(on image: UIImage?) {

        var dataUrl = String.empty
        if let normalized = image?.normalizeOrientation(),
            let url = DataUrl.convert(normalized){
            dataUrl = url
        }

        let request = accountApiService.changeAvatar(dataUrl: dataUrl)
        request.async(apiQueue, completion: { response in
            DispatchQueue.main.async {
                if (response.isFail) {

                    Log.warning(self._tag, "Problem with chage avatar.")
                    self.present(ProblemAlerts.Error(for: response.statusCode), animated: true, completion: nil)
                }
            }
        })
    }

    public func selectTowns() {

        let vc = SelectTownsUIService.initialController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


