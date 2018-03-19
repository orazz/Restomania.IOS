//
//  TabBarController.swift
//  CoreFramework
//
//  Created by Алексей on 21.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit  

public enum TabsPages: Int {
    case search = 1
    case map = 2
    case favourite = 3
    case orders = 4
    case other = 5
}
public class TabsController: UITabBarController {


    //Services
    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)
    private let themeImages = DependencyResolver.get(ThemeImages.self)

    //Data
    private var tabs: [TabsPages: UIViewController] = [:]

    public override func viewDidLoad() {
        super.viewDidLoad()

        let search = SearchController()
        search.tabBarItem = buildTabItem(icon: themeImages.tabSearch)
        tabs[.search] = search

        let orders = OrdersController()
        orders.tabBarItem = buildTabItem(icon: themeImages.tabOrders)
        tabs[.orders] = orders

        let other = OtherController()
        other.tabBarItem = buildTabItem(icon: themeImages.tabsOther)
        tabs[.other] = other

        self.viewControllers = tabs.map({ $0.value })

        tabBar.tintColor = themeColors.actionMain
        tabBar.backgroundColor = themeColors.contentBackground
    }
    private func buildTabItem(icon: UIImage) -> UITabBarItem {

        let selected = icon.tint(color: themeColors.actionContent)
        let deselected = icon.tint(color: themeColors.actionDisabled)

        let item = UITabBarItem(title: "", image: selected, selectedImage: deselected)
        item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        item.title = nil

        return item
    }
}
extension TabsController {
    public func focusOn(_ tab: TabsPages) {

        if let vc = tabs[tab],
            let index = self.viewControllers?.index(where: { $0 === vc }) {
            self.selectedIndex = index
        }
    }
}

