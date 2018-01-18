//
//  PlaceCartPaymentCardsContainerCell.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 09.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class PlaceCartPaymentCardsContainerCell: UITableViewCell {

    public static let height = CGFloat(35)
    private static let nibName = "PlaceCartPaymentCardsContainerCellView"
    public static func create(for card: PaymentCard) -> PlaceCartPaymentCardsContainerCell {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let cell = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceCartPaymentCardsContainerCell

        cell.card = card
        cell.setupMarkup()

        return cell
    }

    //UI
    @IBOutlet private weak var indicator: UIImageView!
    @IBOutlet private weak var numberLabel: UILabel!
    private func setupMarkup() {

        numberLabel.font = ThemeSettings.Fonts.default(size: .head)
        deselect()
    }

    //Data
    private var card: PaymentCard! {
        didSet {
            numberLabel.text = "**** \(card.last4Number)"
        }
    }

    //Actions
    public var cardId: Long {
        return card.ID
    }
    public func select() {
        indicator.isHidden = false
    }
    public func deselect() {
        indicator.isHidden = true
    }
}
