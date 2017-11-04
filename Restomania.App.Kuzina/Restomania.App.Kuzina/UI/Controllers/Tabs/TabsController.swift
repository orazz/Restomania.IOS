//
//  TabBarController.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 21.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit

public class TabsController: UITabBarController {

    @IBOutlet weak var tabbar: UITabBar!

    public override func viewDidLoad() {
        super.viewDidLoad()

        for item in tabbar.items ?? [UITabBarItem]() {

            item.setTitleTextAttributes([NSForegroundColorAttributeName: AppSummary.current.theme.blackColor], for: .selected)
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            item.title = nil
        }
    }
}
