//
//  PlaceCartPaymentCardContainer.swift
//  CoreFramework
//
//  Created by Алексей on 09.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class PlaceCartPaymentCardsContainer: UITableViewCell {

    private static let nibName = "\(String.tag(PlaceCartPaymentCardsContainer.self))View"
    public static func create(with delegate: PlaceCartDelegate) -> PlaceCartPaymentCardsContainer {

        let nib = UINib(nibName: nibName, bundle: Bundle.coreFramework)
        let cell = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceCartPaymentCardsContainer

        cell.delegate = delegate

        return cell
    }

    // UI hooks
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var cardsTable: UITableView!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var addCardButton: UIButton!

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.contentBackground

        titleLabel.font = themeFonts.bold(size: .head)
        titleLabel.textColor = themeColors.contentText
        titleLabel.text = PlaceCartController.Localization.Labels.selectPaymentCard.localized

        cardsTable.dataSource = self
        cardsTable.delegate = self

        addCardButton.setTitle(PlaceCartController.Localization.Buttons.addNewCard.localized, for: .normal)
    }
    @IBAction private func addCard() {
       delegate.addPaymentCard()
    }

    // Data
    private var delegate: PlaceCartDelegate!
    private var reloadHandler: (() -> Void)?
    private var cards: [PaymentCard] = []
    private var container: PlaceCartController.CartContainer {
        return delegate.takeCartContainer()
    }

    private func update() {

        if let cards = delegate.takeCards() {

            self.cards = cards
            cardsTable.reloadData()
            cardsTable.setContraint(.height, to: PlaceCartPaymentCardsContainerCell.height * cards.count)
            reloadHandler?()
        } else {

        }

        if let id = container.cardId {
            select(id)
        } else {
            if let first = cards.first {
                select(first.id)
            }
        }
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

        container.cardId = cardId
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
extension PlaceCartPaymentCardsContainer: PlaceCartContainerCell {

    public func viewDidAppear() {}
    public func viewDidDisappear() {}
    public func updateData(with delegate: PlaceCartDelegate) {
        update()
    }
}
extension PlaceCartPaymentCardsContainer: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return Int(topView.getConstant(.height)! + bottomView.getConstant(.height)! + PlaceCartPaymentCardsContainerCell.height * cards.count )
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
    public func addToContainer(handler: @escaping (() -> Void)) {
        self.reloadHandler = handler
    }
}
