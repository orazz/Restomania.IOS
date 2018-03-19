//
//  CheckPhoneCodeAuthController.swift
//  CoreFramework
//
//  Created by Алексей on 12.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import FirebaseAuth

public class CheckPhoneCodeAuthController: UIViewController {

    //UI
    @IBOutlet private weak var enterCodeLabel: UILabel!
    @IBOutlet private weak var resendCodeLabel: UILabel!
    @IBOutlet private weak var codeField: UITextField!
    @IBOutlet private weak var checkCodeButton: DefaultButton!
    private var interfaceLoader: InterfaceLoader!

    //Services
    private let authApi = DependencyResolver.get(UserAuthApiService.self)
    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    //Data
    private let _tag = String.tag(CheckPhoneCodeAuthController.self)
    private let handler: AuthHandler
    private let verificationId: String
    private let loadQueue: AsyncQueue

    internal init(for verificationId: String, with handler: AuthHandler) {

        self.handler = handler
        self.verificationId = verificationId
        self.loadQueue = AsyncQueue.createForControllerLoad(for: _tag)

        super.init(nibName: String.tag(CheckPhoneCodeAuthController.self), bundle: Bundle.coreFramework)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    //Life circle
    public override func loadView() {
        super.loadView()

        interfaceLoader = InterfaceLoader(for: view)

        loadMarkup()
    }
    private func loadMarkup() {
        view.backgroundColor = themeColors.contentBackground

        enterCodeLabel.text = Localization.labelsEnterCode.localized
        enterCodeLabel.font = themeFonts.default(size: .title)
        enterCodeLabel.textColor = themeColors.contentText

        resendCodeLabel.text = Localization.labelsResendCode.localized
        resendCodeLabel.font = themeFonts.default(size: .caption)
        resendCodeLabel.textColor = themeColors.contentText


        codeField.font = themeFonts.default(size: .head)
        codeField.textColor = themeColors.contentText
        codeField.placeholder = Localization.fieldsCodePlacesholder.localized

        checkCodeButton.setTitle(Localization.buttonsCheckCode.localized, for: .normal)

        navigationItem.title = Localization.title.localized
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
extension CheckPhoneCodeAuthController {
    @IBAction private func checkCode() {

        closeKeyboard()

        guard let code = codeField.text,
                !String.isNullOrEmpty(code) else {
            showToast(Localization.alertsNotCorrectCode)
            return
        }

        interfaceLoader.show()

        let provider = PhoneAuthProvider.provider()
        let credential = provider.credential(withVerificationID: verificationId, verificationCode: code)
        Auth.auth().signIn(with: credential) { (user, error) in
            DispatchQueue.main.async {

                self.interfaceLoader.hide()

                if let error = error {

                    self.showToast(Localization.alertsCheckCodeProblem)

                    Log.warning(self._tag, "Problem with check phone code")
                    print(error.localizedDescription)
                    return
                }

                if let user = user,
                    let token = user.refreshToken {
                    self.addUser(from: token)
                }
            }
        }
    }
    private func addUser(from token: String) {

        interfaceLoader.show()

        let request = authApi.viaPhone(token: token)
        request.async(loadQueue, completion: { response in
            DispatchQueue.main.async {

                self.interfaceLoader.hide()

                if (response.isFail) {
                    self.alert(about: response)
                    return
                }

                let keys = response.data!
                self.handler.complete(success: true, keys: keys)
            }
        })
    }

    @IBAction private func resendCode() {
        navigationController?.popViewController(animated: true)
    }
    @IBAction private func closeKeyboard() {
        view.endEditing(true)
    }
}
extension CheckPhoneCodeAuthController {
    internal enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(CheckPhoneCodeAuthController.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        case title = "Title"

        case labelsEnterCode = "Labels.EnterCode"
        case labelsResendCode = "Labels.ResendCode"

        case fieldsCodePlacesholder = "Fields.Code.Placeholder"

        case buttonsCheckCode = "Buttons.CheckCode"

        case alertsNotCorrectCode = "Alerts.NotCorrectCode"
        case alertsCheckCodeProblem = "Alerts.CheckCodeProblem"
    }
}
