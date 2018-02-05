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
    @IBOutlet private weak var interfaceTable: UITableView!
    private var interfaceAdapter: InterfaceTable!
    private var loader: InterfaceLoader!
    private var refreshControl: UIRefreshControl!
    private var avatarImage: ProfileControllerChangeAvatar!
    private var nameField: FMTextField!
    private var sexSegment: FMSegmentedControl!
    private var ageField: FMTextField!
    private var acquaintancesStatusSwitch: FMSwitch!
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
        loadData()
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

        let width = Double(interfaceTable.frame.width)
        nameField = FMTextField(width: width)
        nameField.title = "Ваше имя"
        nameField.onCompleteChangeEvent =  { self.changeName(on: $1 ?? String.empty) }

        sexSegment = FMSegmentedControl(width: width)
        sexSegment.title = "Кто вы?"
        sexSegment.values = [
            ("Девушка", UserSex.female),
            ("Парень", UserSex.male)
        ]
        sexSegment.onChangeEvent = { self.changeSex(on: ($2 as? UserSex) ?? .unknown) }

        ageField = FMTextField(width: width)
        ageField.title = "Сколько вам лет"
        ageField.valueType = .number
        ageField.onCompleteChangeEvent = { self.changeAge(on: $1 ?? String.empty) }

        acquaintancesStatusSwitch = FMSwitch(width: width)
        acquaintancesStatusSwitch.title = "Заинтересованы во встречах?"
        acquaintancesStatusSwitch.onChangeEvent = { self.changeStatus(on:  $1 ? .readyForAcquaintance : .hidden) }

        let rows = loadRows()
        interfaceAdapter = InterfaceTable(source: self.interfaceTable, rows: rows)
        loader = InterfaceLoader(for: self.view)
        refreshControl = interfaceTable.addRefreshControl(target: self, selector: #selector(needReload))

        self.view.backgroundColor = ThemeSettings.Colors.background
        self.fieldsStorage = self.closeKeyboardWhenTapOnRootView(views: [interfaceTable as UIView] + rows.map({ $0 as! UIView }))
    }
    private func loadRows() -> [InterfaceTableCellProtocol] {

        var result = [InterfaceTableCellProtocol]()

        avatarImage = ProfileControllerChangeAvatar.create(for: self)
        result.append(avatarImage)
        result.append(ProfileControllerSpace.create())

        result.append(FMTextFieldRow.create(for: nameField))
        result.append(ProfileControllerSpace.create())

        result.append(FMSegmentedControlRow.create(for: sexSegment))
        result.append(ProfileControllerSpace.create())

        result.append(FMTextFieldRow.create(for: ageField))
        result.append(ProfileControllerSpace.create())

        result.append(FMSwitchRow.create(for: acquaintancesStatusSwitch))
        result.append(ProfileControllerSpace.create())

        result.append(ProfileControllerSpace.create())
        result.append(ProfileControllerSelectTowns.create(for: self))

        return result
    }

    private func loadData() {

        loader.show()
        requestData()
    }
    @objc private func needReload() {
        requestData()
    }
    private func requestData() {

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

        loader.hide()
        refreshControl.endRefreshing()

        self.account = account
        if let account = account {
            apply(account: account)
        }
    }
    private func apply(account: User) {

        avatarImage.update(avatar: account.image)
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


