//
//  PlaceCartTotalContainerCell.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class PlaceCartTotalContainerCell: UITableViewCell {

    private static let nibName = "PlaceCartTotalContainerCellView"
    public static func create(for title: String, with delegate: PlaceCartDelegate) -> PlaceCartTotalContainerCell {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let cell = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceCartTotalContainerCell

        cell.delegate = delegate
        cell.cells =
        cell.setupMarkup()

        return cell
    }

    //UI hooks


    //Data
    private let _tag = String.tag(PlaceCartTotalContainerCell.self)
    private let guid = Guid.new
    private var delegate: PlaceCartDelegate!
    private var cart: Cart {
        return delegate.takeCart()
    }

    private func apply() {

    }
    private func tryUpdate() {

    }
    private func setupMarkup() {

    }
}
extension PlaceCartTotalContainerCell: CartUpdateProtocol {
    public func cart(_ cart: Cart, changedDish: Dish, newCount: Int) {

    }
    public func cart(_ cart: Cart, removedDish: Long) {
        tryUpdate()
    }
}
extension PlaceCartTotalContainerCell: PlaceCartContainerCell {
    public func viewDidAppear() {
        cart.subscribe(guid: guid, handler: self, tag: _tag)
    }
    public func viewDidDisappear() {
        cart.unsubscribe(guid: guid)
    }
    public func updateData(with: PlaceCartDelegate) {
        tryUpdate()
    }
}
extension PlaceCartTotalContainerCell: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        return 25
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
