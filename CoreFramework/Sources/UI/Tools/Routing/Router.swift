//
//  Router.swift
//  UITools
//
//  Created by Алексей on 22.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public protocol Router {

    func initialize(with controller: UINavigationController)
    func initialize(with controller: UITabBarController)

    var navigator: UINavigationController? { get }
//    var search: UIViewController { get }
//    var map: UIViewController { get }
//    var favourite: UIViewController { get }
//    var manager: UIViewController { get }
//
//    func goBack()
//
//    func goToGreeting()
//    func goToTabs()
//
    func goToPlaceMenu(placeId: Long)
//    func goToPlaceInfo(summary: PlaceSummary)
//    func goToPlaceCart(placeId: Long)
//    func goToCompleteOrder(order: DishOrder)
//
//    func goToOrder(orderId: Long, reset: Bool)
//    func goToOrder(order: DishOrder, reset: Bool)
//
//    func goToAction()
//
//    func selectTabSearch()
//    func selectTabMap()
//    func selectTabFavourite()
//    func selectFeeds()
//    func selectTabManager()
}
extension Router {
    public func push(_ vc: UIViewController, animated: Bool) {
        navigator?.pushViewController(vc, animated: animated)
    }
}
