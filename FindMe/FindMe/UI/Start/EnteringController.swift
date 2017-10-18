//
//  EnteringController.swift
//  FindMe
//
//  Created by Алексей on 02.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import AsyncTask
import IOSLibrary

public class EnteringController: UIViewController {

    private static let nibName = "EnteringController"
    public static func build(parent: StartController) -> EnteringController {

        let instance = EnteringController(nibName: nibName, bundle: Bundle.main)

        instance.startController = parent

        return instance
    }

    //MARK: UIElements
    @IBOutlet public weak var nameTextField: FMTextField!
    @IBOutlet public weak var SexSegmentControl: FMSegmentedControl!
    @IBOutlet public weak var ageTextField: FMTextField!
    @IBOutlet public weak var acquaintancesStatusSwitch: FMSwitch!

    @IBOutlet public weak var firstDividerView:UIView!
    @IBOutlet public weak var secondDividerView:UIView!

    @IBOutlet public weak var vkButton: UIButton!


    //MARK: Data & Services
    private var startController: StartController!

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

        initMarkup()
        fieldsStorage = self.closeKeyboardWhenTapOnRootView()

        super.viewDidAppear(animated)
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.unsubscribefromScrollWhenKeyboardShow()
    }
    private func initMarkup() {

        self.view.backgroundColor = ThemeSettings.Colors.background 

        nameTextField.title = "Ваше имя"
        SexSegmentControl.title = "Кто вы?"
        SexSegmentControl.values = [
            "Парень": UserSex.male,
            "Девушка": UserSex.female
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
    }


    //MARK: Actions
    @IBAction public func continueWithoutAuth() {

        startController.toSearch()
    }
    @IBAction public func authViaVk() {

        let service = VKAuthorizationController.build(callback: { success, result in

            self.continueWithoutAuth()
        })

        self.navigationController?.present(service, animated: true, completion: nil)
    }
}
