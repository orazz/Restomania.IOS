//
//  PlaceCompleteOrderController.swift
//  CoreFramework
//
//  Created by Алексей on 09.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit 

public class PlaceCompleteOrderController: UIViewController {

    //UI
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dataLabel: UILabel!

    @IBOutlet private weak var toOrderButton: UIButton!
    @IBOutlet private weak var toSearchButton: UIButton!

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    //Data
    private var order: DishOrder
    private let cart: CartService

    public init(for order: DishOrder) {

        self.order = order
        self.cart = DependencyResolver.get(PlaceCartsFactory.self).get(for: order.placeId)

        let nibnme = String.tag(PlaceCompleteOrderController.self)
        super.init(nibName: nibnme, bundle: Bundle.coreFramework)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    //Load circle
    public override func loadView() {
        super.loadView()

        setupMarkup()
    }
    private func setupMarkup() {

        view.backgroundColor = themeColors.contentBackground

        titleLabel.text = Localization.labelsTitle.localized
        titleLabel.font = themeFonts.default(size: .head)
        titleLabel.textColor = themeColors.contentText

        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.utc
        formatter.dateFormat = Localization.labelsDateTimeFormat.localized
        let completeAt = formatter.string(from: order.summary.completeAt)

        dataLabel.text =  String(format: Localization.labelsContent.localized, "\(order.id)", completeAt)
        dataLabel.font = themeFonts.bold(size: .head)
        dataLabel.textColor = themeColors.contentText

        toOrderButton.setTitle(Localization.buttonsToOrder.localized, for: .normal)
        toSearchButton.setTitle(Localization.buttonsToSearch.localized, for: .normal)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        cart.clear()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.setStatusBarStyle(from: themeColors.statusBarOnContent)
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: Actions
extension PlaceCompleteOrderController {
    @IBAction private func goToOrder() {

        if let tabs = navigationController?.viewControllers.first(where: { $0 is TabsController }) {

            DispatchQueue.main.async {
                self.navigationController?.popToViewController(tabs, animated: false)
                let navigator = tabs.navigationController

                DispatchQueue.main.async {
                    let vc = OneOrderController(for: self.order.id)
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
    public enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(PlaceCompleteOrderController.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        case labelsTitle = "Labels.Title"
        case labelsDateTimeFormat = "Labels.DateTimeFormat"
        case labelsContent = "Labels.Content"

        case buttonsToOrder = "Buttons.ToOrder"
        case buttonsToSearch = "Buttons.ToSearch"
    }
}
