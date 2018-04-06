//
//  PlaceCartCheckContainer.swift
//  CoreFramework
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class PlaceCartCheckContainer: UIView {

    public static func create(for delegate: PlaceCartDelegate) -> PlaceCartCheckContainer {

        let nibName = String.tag(PlaceCartCheckContainer.self)
        let cell: PlaceCartCheckContainer = UINib.instantiate(from: nibName, bundle: Bundle.coreFramework)

        cell.delegate = delegate

        return cell
    }

    //UI elements
    @IBOutlet private weak var content: UIView!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentTable: UITableView!
    private var heightConstraint: NSLayoutConstraint!

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    //Data
    private let _tag = String.tag(PlaceCartCheckContainer.self)
    private let guid = Guid.new
    private var rows: [PlaceCartElement & PlaceCartDishRow] = []
    private var totalRow: (PlaceCartElement & PlaceCartTotalRow)!
    private var delegate: PlaceCartDelegate?
    private var menu: MenuSummary? {
        return delegate?.takeMenu()
    }
    private var cart: CartService? {
        return delegate?.takeCart()
    }


    public override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initialize()
    }
    private func initialize() {
        connect()
        loadViews()
    }
    private func connect() {
        let nibName = String.tag(PlaceCartCheckContainer.self)
        Bundle.coreFramework.loadNibNamed(nibName, owner: self, options: nil)
        self.addSubview(content)
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        heightConstraint = self.constraints.find({ $0.firstAttribute == .height })
    }
    private func loadViews() {

        backgroundColor = themeColors.contentBackground
        content.backgroundColor = themeColors.contentBackground

        titleLabel.font = themeFonts.bold(size: .head)
        titleLabel.textColor = themeColors.contentText
        titleLabel.text = PlaceCartController.Localization.Labels.dishes.localized

        totalRow = PlaceCartTotalRow.create(for: self.delegate)
    }

    private func update() {

        guard let cart = cart,
                let menu = menu else {
            return
        }

        trigger({ $0.cartWillDisappear() })
        rows.removeAll()

        for dish in cart.dishes {
            rows.append(PlaceCartDishRow.create(for: dish, with: cart, and: menu))
        }

        trigger({ $0.cartWillAppear() })
        if let delegate = self.delegate {
            trigger({ $0.update(with: delegate) })
        }

        contentTable.reloadData()
        resize()
    }
    private func resize() {
        let tableHeight = totalRow.height() + CGFloat(rows.sum({ Int($0.height()) }))
        let height = topView.getConstant(.height)! + tableHeight
        heightConstraint.constant = height
        contentTable.setContraint(.height, to: tableHeight)

        UIView.animate(withDuration: 0.3) {
            self.contentTable.layoutIfNeeded()
        }

        delegate?.resize()
    }
}
extension PlaceCartCheckContainer: UITableViewDelegate {
    
}
extension PlaceCartCheckContainer: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (0 == section) {
            return rows.count
        }
        else if (1 == section) {
            return 1
        }
        else {
            return 0
        }
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (0 == indexPath.section) {
            return rows[indexPath.row].height()
        }
        else if (1 == indexPath.section) {
            return totalRow.height()
        }
        else {
            return 0.0
        }
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (0 == indexPath.section) {
            return rows[indexPath.row]
        }
        else if (1 == indexPath.section) {
            return totalRow
        }
        else {
            return UITableViewCell(style: .default, reuseIdentifier: nil)
        }
    }
}
extension PlaceCartCheckContainer: CartServiceDelegate {

    public func cart(_ cart: CartService, change dish: AddedOrderDish) {
        if (dish.count == 1) {
            update()
        }
    }
    public func cart(_ cart: CartService, remove dish: AddedOrderDish) {
        update()
    }
}
extension PlaceCartCheckContainer: PlaceCartElement {

    public func cartWillAppear() {
        trigger({ $0.cartWillAppear() })
        totalRow.cartWillAppear()

        cart?.subscribe(guid: guid, handler: self, tag: _tag)
    }
    public func cartWillDisappear() {
        trigger({ $0.cartWillDisappear() })
        totalRow.cartWillDisappear()

        cart?.unsubscribe(guid: guid)
    }
    public func update(with delegate: PlaceCartDelegate) {
        totalRow.update(with: delegate)

        self.delegate = delegate
        update()
    }
    private func trigger(_ action: Action<PlaceCartElement>){
        for row in rows {
            action(row)
        }
    }
    public func height() -> CGFloat {
        return heightConstraint.constant
    }
}
