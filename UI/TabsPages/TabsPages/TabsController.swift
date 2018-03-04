//
//  TabBarController.swift
//  Kuzina
//
//  Created by Алексей on 21.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import CoreTools
import UITools
import UIElements

public class TabsController: UITabBarController {

    //UI
    @IBOutlet weak var tabbar: UITabBar!

    //Services
    private let colorsTheme = DependencyResolver.resolve(ThemeColors.self)

    public override func viewDidLoad() {
        super.viewDidLoad()

        for item in tabbar.items ?? [UITabBarItem]() {

            item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: colorsTheme.actionContent], for: .selected)
            item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: colorsTheme.actionDisabled], for: .normal)
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            item.title = nil
        }
    }
}
