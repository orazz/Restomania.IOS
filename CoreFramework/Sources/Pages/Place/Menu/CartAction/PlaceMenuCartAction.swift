//
//  PlaceMenuCartAction.swift
//  CoreFramework
//
//  Created by Алексей on 07.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class PlaceMenuCartAction: UIView {

    //UI elements
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var totalLabel: PriceLabel!
    private var heightConstraint: NSLayoutConstraint?

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    //Data
    private let _tag = String.tag(PlaceMenuCartAction.self)
    private let guid = Guid.new
    private var cart: CartService!
    private var menu: ParsedMenu?
    public var delegate: PlaceMenuDelegate? {
        didSet {

            if let placeId = delegate?.placeId {
                cart = DependencyResolver.get(PlaceCartsFactory.self).get(for: placeId)
            }
            menu = delegate?.takeMenu()

            refresh()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }
    public required init(coder: NSCoder) {
        super.init(coder: coder)!

        initialize()
    }
    private func initialize() {

        connect()
    }
    private func connect() {

        let nibname = String.tag(PlaceMenuCartAction.self)
        let bundle = Bundle.coreFramework
        bundle.loadNibNamed(nibname, owner: self, options: nil)

        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.setContraint(height: DistanceLabel.height)
        contentView.setContraint(width: DistanceLabel.width)

        for constraint in self.constraints {
            if (constraint.firstAttribute == .height) {
                heightConstraint = constraint
                break
            }
        }
    }
    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.actionMain
        contentView.backgroundColor = themeColors.actionMain

        countLabel.textColor = themeColors.actionContent
        countLabel.font = themeFonts.default(size: .title)

        titleLabel.textColor = themeColors.actionContent
        titleLabel.font = themeFonts.default(size: .title)
        titleLabel.text = PlaceMenuController.Localization.buttonAddToCart.localized

        totalLabel.textColor = themeColors.actionContent
        totalLabel.font = themeFonts.default(size: .head)
    }

    private func refresh() {

        DispatchQueue.main.async {
            guard let cart = self.cart else {
                return
            }
            self.countLabel.text = cart.dishes.sum({ $0.count }).description
            self.refreshHeight()

            guard let menu = self.menu else {
                    return
            }
            self.totalLabel.setup(price: cart.total(with: menu.source),
                                currency: menu.currency)
        }
    }
    private func refreshHeight() {

        if (cart?.isEmpty ?? true) {
            close()
        }
        else {
            open()
        }
    }
    public func open(force: Bool = false) {
        heightConstraint?.constant = 50

        animate(force: force)
    }
    public func close(force: Bool = false) {
        heightConstraint?.constant = 0

        animate(force: force)
    }
    private func animate(force: Bool) {

        if (force) {
            layoutIfNeeded()
            return
        }

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }

    @IBAction private func goToCart() {
        delegate?.goToCart()
    }
}

extension PlaceMenuCartAction: PlaceMenuElementProtocol {

    public func viewWillAppear() {
        cart.subscribe(guid: guid, handler: self, tag: _tag)

        refresh()
    }
    public func viewDidDisappear() {
        cart.unsubscribe(guid: guid)
    }
    public func update(delegate: PlaceMenuDelegate) {
        
        menu = delegate.takeMenu()
        refresh()
    }
}
extension PlaceMenuCartAction: CartServiceDelegate {
    public func cart(_ cart: CartService, change dish: AddedOrderDish) {
        refresh()
    }
    public func cart(_ cart: CartService, remove dish: AddedOrderDish) {
        refresh()
    }
}
