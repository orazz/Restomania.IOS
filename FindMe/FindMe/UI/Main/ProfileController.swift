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

public class ProfileController: UIViewController {

    //MARK: UI elements
    @IBOutlet public weak var avatarImage: ImageWrapper!
    @IBOutlet public weak var nameField: FMTextField!
    @IBOutlet public weak var sexSegment: FMSegmentedControl!
    @IBOutlet public weak var ageField: FMTextField!
    @IBOutlet public weak var acquaintancesStatusSwitch: FMSwitch!
    private var _loader: InterfaceLoader!
    private var _fieldsStorage: UIViewController.TextFieldsStorage?
    private var imagePicker: UIImagePickerController!


    //MARK: Data & services
    private let _tag = String.tag(ProfileController.self)
    private var account: User?
    private var loadQueue: AsyncQueue!
    private let accountApiService = ApiServices.Users.main



    //MARK: Life circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        loadQueue = AsyncQueue.createForControllerLoad(for: tag)

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

        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = avatarImage.frame.width / 2
        avatarImage.layer.borderColor = ThemeSettings.Colors.main.cgColor
        avatarImage.layer.borderWidth = 3.0

        nameField.title = "Ваше имя"
        nameField.onCompleteChangeEvent = changeName(_:value:)

        sexSegment.title = "Кто вы?"
        sexSegment.values = [
            ("Девушка", UserSex.female),
            ("Парень", UserSex.male)
        ]
        sexSegment.onChangeEvent = changeSex(_:index:value:)

        ageField.title = "Сколько вам лет"
        ageField.valueType = .number
        ageField.onCompleteChangeEvent = changeAge(_:value:)

        acquaintancesStatusSwitch.title = "Заинтересованы во встречах?"
        acquaintancesStatusSwitch.onChangeEvent = changeStatus(_:value:)


        _loader = InterfaceLoader(for: self.view)

        self.view.backgroundColor = ThemeSettings.Colors.background
        self._fieldsStorage = self.closeKeyboardWhenTapOnRootView()

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }
    private func startLoadData() {

        _loader.show()

        loadData()
    }
    @objc private func refreshData() {
        loadData()
    }
    private func loadData() {

        let request = accountApiService.find()
        request.async(.background, completion: { response in
            DispatchQueue.main.async {

                if (response.isFail) {
                    self.present(ProblemAlerts.Error(for: response.statusCode), animated: true, completion: nil)
                }

                self.completeLoad(response.data)
            }
        })
    }
    private func completeLoad(_ account: User?) {

        self._loader.hide()

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

        let request = accountApiService.change(updates: [update])
        request.async(.background, completion: { response in
            DispatchQueue.main.async {
                if (response.isFail) {

                    Log.Warning(self._tag, "Problem with update profile. Try update 'User.\(update.property)' on '\(update.update)'")

                    self.present(ProblemAlerts.NotConnection, animated: true, completion: nil)
                }
            }
        })
    }
    private func changeAvatar(by image: UIImage) {


        if  let normalized = image.normalizeOrientation(),
            let dataUrl = DataUrl.convert(normalized) {

            let request = accountApiService.changeAvatar(dataUrl: dataUrl)
            request.async(.background, completion: { response in
                DispatchQueue.main.async {
                    if (response.isFail) {

                        Log.Warning(self._tag, "Problem with chage avatar.")

                        self.present(ProblemAlerts.Error(for: response.statusCode), animated: true, completion: nil)
                    }
                }
            })
        }
    }
}
//MARK: Actions
extension ProfileController {

    @IBAction private func changeAvatar() {

        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary

        self.present(imagePicker, animated: true, completion: nil)
    }

    @IBAction private func selectTowns() {

        let vc = SelectTownsUIService.initialController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileController: UIImagePickerControllerDelegate {


    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            avatarImage.contentMode = .scaleAspectFill
            avatarImage.image = pickedImage

            changeAvatar(by: pickedImage)
        }

        picker.dismiss(animated: true, completion: nil)
    }
}
extension ProfileController: UINavigationControllerDelegate {

}

