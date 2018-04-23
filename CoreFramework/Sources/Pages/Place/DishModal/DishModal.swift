//
//  DishModal.swift
//  CoreFramework
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class DishModal: UIViewController {

    //UI
    @IBOutlet private weak var interfaceTable: UITableView!
    private var interfaceAdapter: InterfaceTable!
    private var interfaceRows: [InterfaceTableCellProtocol] = []
    @IBOutlet private weak var addToCartAction: DishModalAddToCartAction!
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return themeColors.statusBarOnContent
    }

    private let themeColors = DependencyResolver.get(ThemeColors.self)


    //Data
    private let _tag = String.tag(DishModal.self)
    private let cart: CartService
    private let dish: ParsedDish
    private let menu: ParsedMenu
    private let addings: [Adding]
    private let vartiations: [Variation]
    private var cartDish: AddedOrderDish?

    public private(set) var selectedVariation: Variation?
    public private(set) var selectedAddingsIds: [Long]
    public private(set) var count: Int
    public private(set) var total: Price

    private var inited: Bool = false

    public convenience init(for dish: ParsedDish, menu: ParsedMenu, with cartDish: AddedOrderDish, and cart: CartService) {

        self.init(dish: dish, menu: menu, with: cart)

        self.cartDish = cartDish
        self.selectedVariation = dish.variation?.range.find({ $0.id == cartDish.variationId })
        self.selectedAddingsIds = cartDish.addings
        self.count = cartDish.count

        completeLoad()
    }
    public convenience init(for dish: ParsedDish, menu: ParsedMenu, and cart: CartService) {

        self.init(dish: dish, menu: menu, with: cart)

        completeLoad()
    }
    private init(dish: ParsedDish, menu: ParsedMenu, with cart: CartService) {

        self.cartDish = nil
        self.selectedVariation = nil
        self.selectedAddingsIds = []
        self.count = 1

        self.dish = dish
        self.menu = menu
        self.cart = cart
        self.addings = dish.addings
        self.vartiations = dish.variation?.range ?? []

        if (dish.type == .simpleDish) {
            self.total = dish.price
        } else {
            self.total = Price.zero
        }

        super.init(nibName: String.tag(DishModal.self), bundle: Bundle.coreFramework)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    //Load circle
    private func completeLoad() {

        view.backgroundColor = themeColors.divider
        interfaceTable.backgroundColor = themeColors.divider

        interfaceRows = loadRows()
        interfaceRows.each({ row in
            if let row = row as? DishModalElementProtocol {
                row.link(with: self)
            }
        })
        interfaceAdapter = InterfaceTable(source: interfaceTable, rows: interfaceRows)

        addToCartAction.link(with: self)

        self.inited = true
        refreshTotal()
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    private func loadRows() -> [InterfaceTableCellProtocol] {

        var result = [InterfaceTableCellProtocol]()

        result.append(DishModalHeader.create(for: dish))
        result.append(DishModalPriceAndSize.create(for: dish))

        result.append(DishModalSpace.create())
        result.append(DishModalSelectPicker.create(with: self))

        if (vartiations.isFilled) {
            result.append(DishModalSelectHeader.create(with: DishModal.Localization.labelsSelectVariations.localized))
            result.append(DishModalSelectVariations.create(for: self.vartiations, with: dish.currency, with: self))
        }

        if (addings.isFilled) {
            result.append(DishModalSelectHeader.create(with: DishModal.Localization.labelsSelectAddings.localized))
            result.append(DishModalSelectAddings.create(for: self.addings, from: menu, with: self))
        }

        result.append(DishModalSpace.create())
        result.append(DishModalSpace.create())

        return result
    }
}
extension DishModal: DishModalDelegate {
    
    public func closeModal() {
        self.dismiss(animated: true, completion: nil)
    }
    public func addToCart() {
        closeModal()

        if let cartDish = cartDish {
            cartDish.update(count, use: selectedVariation?.id, with: selectedAddingsIds, and: [])
            cart.change(cartDish)
        }
        else {
            cart.add(dishId: dish.id, count: count, with: selectedAddingsIds, use: selectedVariation?.id)
        }
    }

    public var isAddNewDish: Bool {
        return nil == cartDish
    }

    public func add(adding dish: ParsedDish) {

        if (nil != selectedAddingsIds.find({ $0 == dish.id })) {
            return
        }

        selectedAddingsIds.append(dish.id)
        total = total + dish.price
    }
    public func remove(adding dish: ParsedDish) {

        guard let index = selectedAddingsIds.index(where: { $0 == dish.id }) else {
            return
        }

        selectedAddingsIds.remove(at: index)
        total = total - dish.price
    }

    public func select(count: Int) {
        self.count = count

        refreshTotal()
    }
    public func select(variation: Variation) {

        if let prev = selectedVariation {
            total = total - prev.price
        }

        selectedVariation = variation
        total = total + variation.price
    }
    private func refreshTotal() {

        if (!inited) {
            return
        }

        self.addToCartAction?.refresh(total: total * count, with: dish.currency)
    }
}
extension DishModal {

    public enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(DishModal.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        //Actions
        case buttonsTryAddDish = "Buttons.TryAddDish"
        case buttonsChangeOrder = "Buttons.ChangeOrder"
        case buttonsAddToCart = "Buttons.AddToCart"

        //Titles
        case labelsSelectCount = "Labels.SelectCount"
        case labelsSelectVariations = "Labels.SelectVariations"
        case labelsSelectAddings = "Labels.SelectAddings"
    }
}
