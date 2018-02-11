//
//  PlaceCompleteOrderController.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 09.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class PlaceCompleteOrderController: UIViewController {

    private static let nibName = "PlaceCompleteOrderControllerView"
    public static func create(for order: DishOrder) -> PlaceCompleteOrderController {

        let instance = PlaceCompleteOrderController(nibName: nibName, bundle: Bundle.main)

        instance.order = order
        let cart = ToolsServices.shared.cart(for: order.placeId)
        cart.clear()

        return instance
    }

    //UI
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dataLabel: UILabel!

    //Data
    private var order: DishOrder!

}

// MARK: Actions
extension PlaceCompleteOrderController {
    @IBAction private func goToOrder() {

        if let tabs = navigationController?.viewControllers.first(where: { $0 is TabsController }) {

            DispatchQueue.main.async {
                self.navigationController?.popToViewController(tabs, animated: false)
                let navigator = tabs.navigationController
//                self.navigationController?.pushViewController(ManagerOrdersController.create(), animated: true)
                DispatchQueue.main.async {
                    let vc = OneOrderController(for: self.order.ID)
                    navigator?.pushViewController(vc, animated: true)
                }
            }
        }

    }
    @IBAction private func goToSearch() {

        if let tabs = navigationController?.viewControllers.first(where: { $0 is TabsController }) {

            navigationController?.popToViewController(tabs, animated: true)
        }
    }
}

// MARK: View circle
extension PlaceCompleteOrderController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupMarkup()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    private func setupMarkup() {

        self.view.backgroundColor = ThemeSettings.Colors.background

        titleLabel.text = "Поздравляем, вы успешно добавлили новый заказ"
        titleLabel.font = ThemeSettings.Fonts.default(size: .head)
        titleLabel.textColor = ThemeSettings.Colors.main

        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.utc
        formatter.dateFormat = "HH:mm dd/MM"
        dataLabel.text = "#\(order.ID) на \(formatter.string(from: order.summary.completeAt))"
        dataLabel.font = ThemeSettings.Fonts.bold(size: .head)
        dataLabel.textColor = ThemeSettings.Colors.main
    }
}
