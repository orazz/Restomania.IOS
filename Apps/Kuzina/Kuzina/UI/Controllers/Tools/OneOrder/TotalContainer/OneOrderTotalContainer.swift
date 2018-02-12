//
//  OneOrderTotalContainer.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 13.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import CoreDomains

public class OneOrderTotalContainer: UITableViewCell {

    private static var nibName = "\(String.tag(OneOrderTotalContainer.self))View"
    public static var instance: OneOrderTotalContainer {

        let cell: OneOrderTotalContainer = UINib.instantiate(from: nibName, bundle: Bundle.main)

        return cell
    }

    //UI
    @IBOutlet private weak var totalTitleLabel: UILabel!
    @IBOutlet private weak var totalValueLabel: PriceLabel!

    public override func awakeFromNib() {
        super.awakeFromNib()

        totalTitleLabel.text = OneOrderController.Keys.totalLabel.localized
        totalTitleLabel.font = ThemeSettings.Fonts.default(size: .head)
        totalTitleLabel.textColor = ThemeSettings.Colors.main

        totalValueLabel.text = String.empty
        totalValueLabel.font = ThemeSettings.Fonts.bold(size: .head)
        totalValueLabel.textColor = ThemeSettings.Colors.main

        backgroundColor = ThemeSettings.Colors.additional
    }
}
extension OneOrderTotalContainer: OneOrderInterfacePart {
    public func update(by update: DishOrder) {
        totalValueLabel.setup(price: update.total, currency: update.currency)
    }
}
extension OneOrderTotalContainer: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return 30
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
