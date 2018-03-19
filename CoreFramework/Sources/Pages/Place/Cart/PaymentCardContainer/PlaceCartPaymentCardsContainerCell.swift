//
//  PlaceCartPaymentCardsContainerCell.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 09.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class PlaceCartPaymentCardsContainerCell: UITableViewCell {

    public static let height = CGFloat(35)
    private static let nibName = String.tag(PlaceCartPaymentCardsContainerCell.self)
    public static func create(for card: PaymentCard) -> PlaceCartPaymentCardsContainerCell {

        let cell: PlaceCartPaymentCardsContainerCell  =  UINib.instantiate(from: nibName, bundle: Bundle.coreFramework)
        cell.card = card

        return cell
    }

    //UI
    @IBOutlet private weak var indicator: UIImageView!
    @IBOutlet private weak var numberLabel: UILabel!

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    public override func awakeFromNib() {
        super.awakeFromNib()

        numberLabel.font = themeFonts.default(size: .head)
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
        return card.id
    }
    public func select() {
        indicator.isHidden = false
    }
    public func deselect() {
        indicator.isHidden = true
    }
}
