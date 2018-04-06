//
//  AddDishToCartModal.swift
//  CoreFramework
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class AddDishToCartModal: UIViewController {

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
    private let _tag = String.tag(AddDishToCartModal.self)
    private let cart: CartService
    private let dish: ParsedDish
    private let addings: [Adding]
    private let vartiations: [Variation]
    private let menu: MenuSummary
    private var cartDish: AddedOrderDish?

    private var selectedVariation: Variation?
    private var selectedAddingsIds: [Long] = []
    public var count: Int{
        didSet {
            refreshTotal()
        }
    }
    private var total: Price {
        didSet {
            refreshTotal()
        }
    }
    private var inited: Bool = false

    public convenience init(for dish: ParsedDish, with cartDish: AddedOrderDish, and cart: CartService) {
        self.init(dish: dish, with: cart)

        self.selectedVariation = nil
        self.selectedAddingsIds = []

        self.count = cartDish.count
        if (dish.type == .simpleDish) {
            self.total = dish.price
        } else {
            self.total = Price.zero
        }

        if let variation = dish.variation?.variations.find({ $0.id == cartDish.variationId }) {
            select(variation: variation)
        }
        for addingId in cartDish.addings {
            if let dish = menu.dishes.find({ $0.id == addingId }) {
                add(adding: dish)
            }
        }

        self.cartDish = cartDish

        completeLoad()
    }
    public convenience init(for dish: ParsedDish, and cart: CartService) {
        self.init(dish: dish, with: cart)

        self.selectedVariation = nil
        self.selectedAddingsIds = []

        self.count = 1
        if (dish.type == .simpleDish) {
            self.total = dish.price
        } else {
            self.total = Price.zero
        }

        completeLoad()
    }
    private init(dish: ParsedDish, with cart: CartService) {
        self.dish = dish
        self.cart = cart
        self.addings = dish.addings
        self.vartiations = dish.variation?.variations ?? []
        self.menu = dish.menu
        self.count = 1
        self.total = Price.zero

        super.init(nibName: "\(String.tag(AddDishToCartModal.self))View", bundle: Bundle.coreFramework)
    }
    public required init?(coder aDecoder: NSCoder) {
        Log.error(_tag, "Not implemented constructor.")
        fatalError("init(coder:) has not been implemented")
    }

    //Load circle
    private func completeLoad() {

        view.backgroundColor = themeColors.divider
        interfaceTable.backgroundColor = themeColors.divider

        interfaceRows = loadRows()
        interfaceRows.each({ row in
            if let row = row as? DishModalElementsProtocol {
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

        result.append(DishModalSelectPicker.create(with: self))

        if (vartiations.isFilled) {
//            result.append(DishModalSpace.create())
            result.append(DishModalSelectHeader.create(with: DishModal.Localization.labelsSelectVariations.localized))
            result.append(DishModalSelectVariations.create(for: self.vartiations, from: menu, with: self))
        }

        if (addings.isFilled) {
//            result.append(DishModalSpace.create())
            result.append(DishModalSelectHeader.create(with: DishModal.Localization.labelsSelectAddings.localized))
            result.append(DishModalSelectAddings.create(for: self.addings, from: menu, with: self))
            result.append(DishModalSpace.create())
            result.append(DishModalSpace.create())
        }

        return result
    }
}
extension AddDishToCartModal: DishModalDelegateProtocol {
    public func closeModal() {
        self.dismiss(animated: true, completion: nil)
    }
    public func addToCart() {
        closeModal()

        if (nil == cartDish) {
            cart.add(dishId: dish.id, count: count, with: selectedAddingsIds, use: selectedVariation?.id)
        }
        else {

        }
    }
}
extension AddDishToCartModal: AddDishToCartModalDelegateProtocol {

    public func add(adding dish: Dish) {

        if (nil != selectedAddingsIds.find({ $0 == dish.id })) {
            return
        }

        selectedAddingsIds.append(dish.id)
        total = total + dish.price
    }
    public func remove(adding dish: Dish) {

        guard let index = selectedAddingsIds.index(where: { $0 == dish.id }) else {
            return
        }

        selectedAddingsIds.remove(at: index)
        total = total - dish.price
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

        self.addToCartAction?.refresh(total: total * count, with: menu.currency)
    }
}
