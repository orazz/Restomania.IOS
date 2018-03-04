//
//  Router.swift
//  Launcher
//
//  Created by Алексей on 05.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import UITools

public class RoutingSystem: Router {

    public private(set) var navigator: UINavigationController?
    public private(set) var tabs: UITabBarController?

    public func initialize(with controller: UINavigationController) {
        self.navigator = controller
    }

    public func initialize(with controller: UITabBarController) {
        self.tabs = controller
    }

//    public var search: UIViewController
//
//    public var map: UIViewController
//
//    public var favourite: UIViewController
//
//    public var manager: UIViewController
//
//    public func goBack(animated: Bool = true) {
//        navigator?.popViewController(animated: animated)
//    }
//
//    public func goToGreeting() {
//        <#code#>
//    }
//
//    public func goToTabs() {
//        <#code#>
//    }
//
//    public func goToPlaceMenu(placeId: Long) {
//        <#code#>
//    }
//
//    public func goToPlaceInfo(summary: PlaceSummary) {
//        <#code#>
//    }
//
//    public func goToPlaceCart(placeId: Long) {
//        <#code#>
//    }
//
//    public func goToCompleteOrder(order: DishOrder) {
//        <#code#>
//    }
//
//    public func goToOrder(orderId: Long, reset: Bool) {
//        <#code#>
//    }
//
//    public func goToOrder(order: DishOrder, reset: Bool) {
//        <#code#>
//    }
//
//    public func goToAction() {
//        <#code#>
//    }
//
//    public func selectTabSearch() {
//        <#code#>
//    }
//
//    public func selectTabMap() {
//        <#code#>
//    }
//
//    public func selectTabFavourite() {
//        <#code#>
//    }
//
//    public func selectFeeds() {
//        <#code#>
//    }
//
//    public func selectTabManager() {
//        <#code#>
//    }


}
