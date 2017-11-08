//
//  PlaceCartDishesContainer.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class PlaceCartDishesContainer: UITableViewCell {

    private static let nibName = "PlaceCartDishesContainerView"
    public static func create(for delegate: PlaceCartDelegate) -> PlaceCartDishesContainer {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let cell = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceCartDishesContainer

        cell.delegate = delegate

        return cell
    }

    //UI elements

    //Data
    private let _tag = String.tag(PlaceCartDishesContainer.self)
    private let guid = Guid.new
    private var delegate: PlaceCartDelegate! {
        didSet {
            update()
        }
    }
    private var cart: Cart {
        return delegate.takeCart()
    }

    private func update() {

    }
    private func setupMarkup() {

    }
}

extension PlaceCartDishesContainer: PlaceCartContainerCell {

    public func viewDidAppear() {
        cart.subscribe(guid: guid, handler: self, tag: _tag)
    }
    public func viewDidDisappear() {
        cart.unsubscribe(guid: guid)
    }
    public func updateData(with delegate: PlaceCartDelegate) {
        self.delegate = delegate
    }
}
extension PlaceCartDishesContainer: CartUpdateProtocol {

    public func cart(_ cart: Cart, changedDish: Dish, newCount: Int) {
        update()
    }
    public func cart(_ cart: Cart, removedDish: Long) {
        update()
    }
}
extension PlaceCartDishesContainer: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return 400
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
