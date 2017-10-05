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

    private static let nibName = "EnteringView"
    public static func build(parent: StartController) -> EnteringController {

        return EnteringController(nibName: nibName, bundle: Bundle.main)
    }

    //MARK: UIElements
    @IBOutlet public weak var VkButton: UIButton!

    //MARK: Data & Services
    private var isInitMarkup: Bool = false


    //MARK: Controller circle
    public override func viewDidLoad() {
        super.viewDidLoad()


    }
    public override func viewWillAppear(_ animated: Bool) {

        initMarkup()

        super.viewWillAppear(animated)
    }
    private func initMarkup() {

        if (isInitMarkup) {
            return
        }
        isInitMarkup = true

        VkButton.backgroundColor = ThemeSettings.Colors.vk
        VkButton.layer.borderColor = ThemeSettings.Colors.vk.cgColor
        VkButton.titleLabel?.textColor = ThemeSettings.Colors.whiteText
        let icon = UIImageView(frame: CGRect(x: 5, y: 5, width: 40, height: 40))
        icon.image = ThemeSettings.Images.vkLogo
        VkButton.addSubview(icon)
    }


    //MARK: Actions
    @IBAction public func continueWithoutAuth() {

    }
    @IBAction public func authViaVk() {

        let service = VKAuthorizationController.build(callback: { success, result in


        })

        self.navigationController?.present(service, animated: true, completion: nil)
    }
}
