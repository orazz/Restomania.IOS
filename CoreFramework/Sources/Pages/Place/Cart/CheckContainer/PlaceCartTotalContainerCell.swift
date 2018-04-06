//
//  PlaceCartTotalRow.swift
//  CoreFramework
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class PlaceCartTotalRow: UITableViewCell {

    public static func create(for delegate: PlaceCartDelegate?) -> PlaceCartTotalRow {

        let nibname = String.tag(PlaceCartTotalRow.self)
        let cell: PlaceCartTotalRow = UINib.instantiate(from: nibname, bundle: Bundle.coreFramework)

        cell.title = PlaceCartController.Localization.Labels.total.localized
        cell.delegate = delegate

        return cell
    }

    //UI hooks
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var totalLabel: PriceLabel!

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    //Data
    private let _tag = String.tag(PlaceCartTotalRow.self)
    private let guid = Guid.new
    private var delegate: PlaceCartDelegate?
    private var title: String!
    private var action: ((CartService, MenuSummary) -> Price)!
    private var cart: CartService? {
        return delegate?.takeCart()
    }

    private func update() {

        if let menu = delegate?.takeMenu(),
            let sum = cart?.total(with: menu) {

            DispatchQueue.main.async {
                self.totalLabel.setup(price: sum, currency: menu.currency)
            }
        }
    }
    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.contentBackground

        titleLabel.font = themeFonts.default(size: .head)
        titleLabel.textColor = themeColors.contentText
        titleLabel.text = title

        totalLabel.font = themeFonts.bold(size: .head)
        totalLabel.textColor = themeColors.contentText
        totalLabel.setup(amount: 0, currency: .RUB)
    }
}
extension PlaceCartTotalRow: CartServiceDelegate {
    public func cart(_ cart: CartService, change dish: AddedOrderDish) {
        update()
    }
    public func cart(_ cart: CartService, remove dish: AddedOrderDish) {
        update()
    }
}
extension PlaceCartTotalRow: PlaceCartElement {
    public func cartWillAppear() {
        cart?.subscribe(guid: guid, handler: self, tag: _tag)
    }
    public func cartWillDisappear() {
        cart?.unsubscribe(guid: guid)
    }
    public func update(with delegate: PlaceCartDelegate) {
        self.delegate = delegate
        update()
    }
    public func height() -> CGFloat {
        return 45
    }
}
