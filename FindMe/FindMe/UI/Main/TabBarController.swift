//
//  TabBarController.swift
//  FindMe
//
//  Created by Алексей on 01.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class TabBarController: UITabBarController {

    @IBOutlet weak var TabBar: UITabBar!

    public override func viewDidLoad() {
        super.viewDidLoad()

        let mainColor = ThemeSettings.Colors.main
        for item in TabBar.items ?? [UITabBarItem]() {

            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: mainColor], for: .selected)
            item.title = nil
        }

        self.TabBar.tintColor = mainColor
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setToolbarHidden(true, animated: false)
    }
}
