//
//  PlaceMenuMenuContainer.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 07.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class PlaceMenuMenuContainer: UITableViewCell {

    private static let nibName = "PlaceMenuMenuContainerView"
    public static func create(with controller: PlaceMenuController) -> PlaceMenuMenuContainer {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceMenuMenuContainer

        instance._menu = nil
        instance._delegate = controller
        instance._controller = controller
        instance._cart = instance._delegate.takeCart()

        instance._categoriesAdapter = CategoriesAdapter(for: instance.categoriesStack, with: instance)
        instance._dishesAdapter = DishesAdapter(for: instance.dishesTable, with: instance)

        instance.setupMarkup()

        return instance
    }

    //UI elements
    @IBOutlet private weak var categoriesStack: UICollectionView!
    @IBOutlet private weak var dishesTable: UITableView!
    private var _categoriesAdapter: CategoriesAdapter!
    private var _dishesAdapter: DishesAdapter!

    //Data & services
    private var _menu: MenuSummary? {
        didSet {
            if let menu = _menu {
                apply(menu)
            }
        }
    }
    private let _tag = String.tag(PlaceMenuMenuContainer.self)
    private let _guid = Guid.new
    private var _delegate: PlaceMenuDelegate!
    private var _controller: UIViewController!
    private var _cart: Cart!

    private func apply(_ menu: MenuSummary) {
        _categoriesAdapter.update(by: menu)
        _dishesAdapter.update(by: menu)
    }

    private func setupMarkup() {

        self.backgroundColor = ThemeSettings.Colors.background

        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: BottomActions.height, right: 0.0)
        dishesTable.contentInset = contentInsets
        dishesTable.scrollIndicatorInsets = contentInsets
    }

    // MARK: Methods
    public func setScroll(_ offset: CGFloat, animated: Bool = false) {
        dishesTable.setContentOffset(CGPoint(x: 0, y: offset), animated: animated)
    }
    public func disableScroll() {
        dishesTable.bounces = false
        dishesTable.alwaysBounceVertical = false
        dishesTable.isScrollEnabled = false

        setScroll(0)
    }
    public func enableScroll() {
        dishesTable.bounces = true
        dishesTable.alwaysBounceVertical = true
        dishesTable.isScrollEnabled = true
    }
}

// MARK: Protocols
extension PlaceMenuMenuContainer: PlaceMenuDelegate {
    public func takeSummary() -> PlaceSummary? {
        return _delegate.takeSummary()
    }
    public func takeMenu() -> MenuSummary? {
        return _delegate.takeMenu()
    }
    public func takeCart() -> Cart {
        return _cart
    }

    public func tryAdd(dish: Long) {
        _delegate.tryAdd(dish: dish)
    }

    public func select(category: Long) {

        if (-1 == category) {
            _dishesAdapter.select(by: nil)
        } else {

            _dishesAdapter.select(by: category)
        }

        let path = IndexPath(row: 0, section: 0)
        if let _ = dishesTable.cellForRow(at: path) {
            dishesTable.scrollToRow(at: path, at: .top, animated: true)
        }
    }
    public func select(dish: Long) {
        _delegate.select(dish: dish)
    }
    public func scrollTo(offset: CGFloat) {
        _delegate.scrollTo(offset: offset)
    }

    public func goBack() {
        _delegate.goBack()
    }
    public func goToCart() {
        _delegate.goToCart()
    }
    public func goToPlace() {
        _delegate.goToPlace()
    }
}
extension PlaceMenuMenuContainer: PlaceMenuCellsProtocol {
    public func viewDidAppear() {
        _cart.subscribe(guid: _guid, handler: self, tag: _tag)
    }
    public func viewDidDisappear() {
        _dishesAdapter.clear()
        _cart.unsubscribe(guid: _guid)
    }
    public func dataDidLoad(delegate: PlaceMenuDelegate) {
        _menu = delegate.takeMenu()
    }
}
extension PlaceMenuMenuContainer: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        return Int(self._controller.view.frame.height) - 64 //44 - UINavigationBar.height, 20 - statusBarOffset
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
extension PlaceMenuMenuContainer: CartUpdateProtocol {
    public func cart(_ cart: Cart, changedDish dishId: Long, newCount: Int) {
        updateButtonOffset()
    }
    public func cart(_ cart: Cart, removedDish dishId: Long) {
        updateButtonOffset()
    }
    private func updateButtonOffset() {

        var offset = BottomActions.height

        if (_cart.isEmpty) {
            offset = CGFloat(0)
        }

        DispatchQueue.main.async {
            self.dishesTable.setParentContraint(.bottom, to: offset)
        }
    }
}
