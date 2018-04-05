//
//  PlaceCartPaymentCardsContainer.swift
//  CoreFramework
//
//  Created by Алексей on 09.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class PlaceCartPaymentCardsContainer: UIView {

    // UI hooks
    @IBOutlet private weak var content: UIView!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var cardsTable: UITableView!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var addCardButton: UIButton!
    @IBOutlet private weak var tableHeightConstraint: NSLayoutConstraint!
    private var heightConstraint: NSLayoutConstraint!
    private var loader: InterfaceLoader!

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

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

        let nibName = String.tag(PlaceCartPaymentCardsContainer.self)
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
        titleLabel.text = PlaceCartController.Localization.Labels.selectPaymentCard.localized

        addCardButton.setTitle(PlaceCartController.Localization.Buttons.addNewCard.localized, for: .normal)

        loader = InterfaceLoader(for: cardsTable)
        loader.show()

        resize()
    }
    @IBAction private func addCard() {
       delegate?.addPaymentCard()
    }

    // Data
    private var delegate: PlaceCartDelegate?
    private var cards: [PaymentCard] = []
    private var container: PlaceCartController.CartContainer? {
        return delegate?.takeCartContainer()
    }

    private func update() {

        if let cards = delegate?.takeCards() {
            self.cards = cards
            cardsTable.reloadData()

            loader.hide()
        }

        if let id = container?.cardId {
            select(id)
        } else {
            if let first = cards.first {
                select(first.id)
            }
        }
        
        resize()
    }

    private func select(_ cardId: Long) {

        for cell in cardsTable.visibleCells {
            if let cell = cell as? PlaceCartPaymentCardsContainerCell {
                if (cell.cardId == cardId) {
                    cell.select()
                } else {
                    cell.deselect()
                }
            }
        }

        container?.cardId = cardId
    }
    private func resize() {

        tableHeightConstraint.constant = max(PlaceCartPaymentCardsContainerCell.height * cards.count, 50.0)
        let height = topView.getConstant(.height)! + tableHeightConstraint.constant + bottomView.getConstant(.height)!
        heightConstraint.constant = height

        UIView.animate(withDuration: 0.3) {
            self.cardsTable.layoutIfNeeded()
        }

        delegate?.resize()
    }
}
extension PlaceCartPaymentCardsContainer: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let cell = tableView.cellForRow(at: indexPath) as? PlaceCartPaymentCardsContainerCell {
            select(cell.cardId)
        }
    }
}
extension PlaceCartPaymentCardsContainer: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return PlaceCartPaymentCardsContainerCell.create(for: cards[indexPath.row])
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PlaceCartPaymentCardsContainerCell.height
    }
}
extension PlaceCartPaymentCardsContainer: PlaceCartElement {

    public func update(with delegate: PlaceCartDelegate) {
        self.delegate = delegate
        update()
    }
    public func height() -> CGFloat {
        return heightConstraint.constant
    }
}

