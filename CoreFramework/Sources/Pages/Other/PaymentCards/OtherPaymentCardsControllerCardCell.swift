//
//  OtherPaymentCardsControllerCardCell.swift
//  CoreFramework
//
//  Created by Алексей on 12.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit

public class OtherPaymentCardsControllerCardCell: UITableViewCell {

    public static let identifier = Guid.new
    public static let height: CGFloat = 50
    private static let nibName = String.tag(OtherPaymentCardsControllerCardCell.self)
    public static func register(in table: UITableView) {

        let nib = UINib.init(nibName: nibName, bundle: Bundle.coreFramework)
        table.register(nib, forCellReuseIdentifier: identifier)
    }

    //UI
    @IBOutlet weak var NumberLabel: UILabel!
    @IBOutlet weak var TypeLabel: UILabel!
    @IBOutlet weak var CloseIcon: UIImageView!

    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    //Data
    private var _card: PaymentCard!
    private var _delegate: IPaymentCardsDelegate!

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.contentBackground

        let font = themeFonts.default(size: .head)
        let color = themeColors.contentText

        NumberLabel.font = font
        NumberLabel.textColor = color

        TypeLabel.font = font
        TypeLabel.textColor = color
    }

    // MARK: Public interfaces
    public func setup(card: PaymentCard, delegate: IPaymentCardsDelegate) {

        _card = card
        _delegate = delegate

        NumberLabel.text = "**** \(_card.last4Number)"
        TypeLabel.text = "\(card.type)"
    }

    public func Remove() {
        tapRemove()
    }
    @IBAction private func tapRemove() {
        _delegate.removeCard(_card.id)
    }
}
