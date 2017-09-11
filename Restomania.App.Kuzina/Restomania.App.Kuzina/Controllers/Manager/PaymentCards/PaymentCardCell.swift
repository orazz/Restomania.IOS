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

    public static let identifier = "PaymentCardCell-\(Guid.New)"

    @IBOutlet public weak var NumberLabel: UILabel!
    @IBOutlet public weak var TypeLabel: UILabel!
    @IBOutlet public weak var CloseIcon: UIImageView!

    private var _card: PaymentCard!
    private var _delegate: IPaymentCardsDelegate!

    public func setup(card: PaymentCard, delegate: IPaymentCardsDelegate) {

        _card = card
        _delegate = delegate

        NumberLabel.text = "**** \(_card.Last4Number)"
        TypeLabel.text = "\(card.Type)"

        let tap = UIGestureRecognizer(target: self, action: #selector(tapRemove))
        CloseIcon.addGestureRecognizer(tap)
        CloseIcon.isUserInteractionEnabled = true
    }
    @objc private func tapRemove() {

        _delegate.removeCard(id: _card.ID)
    }
    private func setupStyles() {

    }
}
