//
//  AddDishToCartModal.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import CoreDomains
import Localization

public class AddDishToCartModal: UIViewController {

    //UI
    @IBOutlet private weak var interfaceTable: UITableView!
    private var interfaceAdapter: InterfaceTable!
    private var interfaceRows: [InterfaceTableCellProtocol] = []
    @IBOutlet private weak var addToCartAction: DishModalAddToCartAction!

    //Data
    private let _tag = String.tag(AddDishToCartModal.self)
    private let dish: Dish
    private let addings: [Adding]
    private let vartiations: [Variation]
    private let menu: MenuSummary
    private let delegate: PlaceMenuDelegate

    private var selectedVariation: Variation?
    private var selectedAddingsIds: [Long]
    private var total: Price {
        didSet {
            refreshTotal()
        }
    }

    public init(for dish: Dish, with addings: [Adding], and variations: [Variation], from menu: MenuSummary, with delegate: PlaceMenuDelegate) {

        self.dish = dish
        self.addings = addings
        self.vartiations = variations
        self.menu = menu
        self.delegate = delegate

        self.selectedVariation = nil
        self.selectedAddingsIds = []

        if (dish.type == .simpleDish) {
            self.total = dish.price
        } else {
            self.total = Price.zero
        }

        super.init(nibName: "\(String.tag(AddDishToCartModal.self))View", bundle: Bundle.main)
    }
    public required init?(coder aDecoder: NSCoder) {
        Log.error(_tag, "Not implemented constructor.")
        fatalError("init(coder:) has not been implemented")
    }

    //Load circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        loadMarkup()

    }
    private func loadMarkup() {

        interfaceRows = loadRows()
        interfaceRows.each({ row in
            if let row = row as? DishModalElementsProtocol {
                row.link(with: self)
            }
        })
        interfaceAdapter = InterfaceTable(source: interfaceTable, rows: interfaceRows)

        addToCartAction.link(with: self)
        refreshTotal()
    }
    private func loadRows() -> [InterfaceTableCellProtocol] {

        var result = [InterfaceTableCellProtocol]()

        result.append(DishModalHeader.create(for: dish, from: menu))
        result.append(DishModalPriceAndSize.create(for: dish, from: menu))

        if (vartiations.isFilled) {
            result.append(DishModalSpace.create())
            result.append(DishModalSelectHeader.create(with: Localization.DishModals.labelsSelectVariations.localized))
            result.append(DishModalSelectVariations.create(for: self.vartiations, from: menu, with: self))
        }

        if (addings.isFilled) {
            result.append(DishModalSpace.create())
            result.append(DishModalSelectHeader.create(with: Localization.DishModals.labelsSelectAddings.localized))
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
        delegate.add(dish, with: selectedAddingsIds, use: selectedVariation?.ID)
    }
}
extension AddDishToCartModal: AddDishToCartModalDelegateProtocol {

    public func add(adding dish: Dish) {

        if (nil != selectedAddingsIds.find({ $0 == dish.ID })) {
            return
        }

        selectedAddingsIds.append(dish.ID)
        total = total + dish.price
    }
    public func remove(adding dish: Dish) {

        guard let index = selectedAddingsIds.index(where: { $0 == dish.ID }) else {
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
        self.addToCartAction?.refresh(total: total, with: menu.currency)
    }
}
