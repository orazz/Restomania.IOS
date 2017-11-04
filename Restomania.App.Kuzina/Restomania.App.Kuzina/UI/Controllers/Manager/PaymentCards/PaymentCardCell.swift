//
//  File.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 12.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import IOSLibrary

public class PaymentCardCell: UITableViewCell {

    public static let identifier = "PaymentCardCell-\(Guid.new)"
    public static let nibName = "PaymentCardCellView"
    public static let height: CGFloat = 50

    @IBOutlet weak var NumberLabel: UILabel!
    @IBOutlet weak var TypeLabel: UILabel!
    @IBOutlet weak var CloseIcon: UIImageView!

    private var _card: PaymentCard!
    private var _delegate: IPaymentCardsDelegate!
    private var _isSetupMarkup: Bool = false

    // MARK: Public interfaces
    public func setup(card: PaymentCard, delegate: IPaymentCardsDelegate) {

        _card = card
        _delegate = delegate

        NumberLabel.text = "**** \(_card.Last4Number)"
        TypeLabel.text = "\(card.Type)"

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapRemove))
        CloseIcon.addGestureRecognizer(tap)
        CloseIcon.isUserInteractionEnabled = true

        setupStyles()
    }
    public func Remove() {
        tapRemove()
    }
    @objc private func tapRemove() {

        _delegate.removeCard(id: _card.ID)
    }

    private func setupStyles() {

        if (_isSetupMarkup) {

            return
        }

        let font = ThemeSettings.Fonts.default(size: .head)
        NumberLabel.font = font
        TypeLabel.font = font

        _isSetupMarkup = true
    }
}
