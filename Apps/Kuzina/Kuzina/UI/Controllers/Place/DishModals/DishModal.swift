//
//  DishModal.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import CoreDomains

public class DishModal: UIViewController {

    //UI
    @IBOutlet private weak var interfaceTable: UITableView!
    private var interfaceAdapter: InterfaceTable!
    private var interfaceRows: [DishModalElementsProtocol] = []
    @IBOutlet private weak var tryAddDishAction: DishModalTryAddingAction!

    //Data
    private let _tag = String.tag(DishModal.self)
    private let dish: BaseDish
    private let menu: MenuSummary
    private let delegate: PlaceMenuDelegate

    public init(for dish: BaseDish, from menu: MenuSummary, with delegate: PlaceMenuDelegate) {

        self.dish = dish
        self.menu = menu
        self.delegate = delegate

        super.init(nibName: "\(String.tag(DishModal.self))View", bundle: Bundle.main)
    }
    public required init?(coder aDecoder: NSCoder) {
        Log.error(_tag, "Problem with not implemented constructor.")
        fatalError("init(coder:) has not been implemented")
    }

    //Load circle
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    public override func viewDidLoad() {
        super.viewDidLoad()

        loadMarkup()
    }

    private func loadMarkup() {

        interfaceRows = loadRows()
        interfaceAdapter = InterfaceTable(source: interfaceTable, rows: interfaceRows)

        interfaceRows.each({ $0.link(with: self) })

        tryAddDishAction.link(with: self)
    }
    private func loadRows() -> [DishModalElementsProtocol] {

        var result = [DishModalElementsProtocol]()

        result.append(DishModalHeader.create(for: dish, from: menu))

        result.append(DishModalPriceAndSize.create(for: dish, from: menu))

        let description = DishModalDescription.create(for: dish, with: menu)
        result.append(DishModalShortDivider.create(for: description))
        result.append(description)

        return result
    }
}
extension DishModal: DishModalDelegateProtocol {

    public func closeModal() {
        self.dismiss(animated: true, completion: nil)
    }
    public func addToCart() {
//        self.closeModal()
        self.delegate.tryAdd(dish.ID)
    }
}
