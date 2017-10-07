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

        let instance = EnteringController(nibName: nibName, bundle: Bundle.main)

        instance.startController = parent

        return instance
    }

    //MARK: UIElements
    @IBOutlet public weak var VkButton: UIButton!

    //MARK: Data & Services
    private var isInitMarkup: Bool = false
    private var startController: StartController!


    //MARK: Controller circle
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initMarkup()

        self.navigationController?.setToolbarHidden(true, animated: false)
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

        startController.toSearch()
    }
    @IBAction public func authViaVk() {

        let service = VKAuthorizationController.build(callback: { success, result in

            self.continueWithoutAuth()
        })

        self.navigationController?.present(service, animated: true, completion: nil)
    }
}