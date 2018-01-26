//
//  NavigationController.swift
//  FindMe
//
//  Created by Алексей on 01.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class NavigationController: UINavigationController {

    private let _tag = String.tag(NavigationController.self)

    public override func viewDidLoad() {
        super.viewDidLoad()

        Log.Info(_tag, "Main navigation controller load.")
        navigationBar.isTranslucent = false
        navigationBar.backgroundColor = ThemeSettings.Colors.background
    }
}
