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

public class OneOrderTotalContainer: UITableViewCell {

    public static var instance: OneOrderTotalContainer {
        return UINib.instantiate(from: String.tag(OneOrderTotalContainer.self), bundle: Bundle.coreFramework)
    }

    //UI
    @IBOutlet private weak var totalTitleLabel: UILabel!
    @IBOutlet private weak var totalValueLabel: PriceLabel!

    //Theme
    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    public override func awakeFromNib() {
        super.awakeFromNib()

        totalTitleLabel.text = OneOrderController.Keys.totalLabel.localized
        totalTitleLabel.font = themeFonts.default(size: .head)
        totalTitleLabel.textColor = themeColors.contentBackgroundText

        totalValueLabel.text = String.empty
        totalValueLabel.font = themeFonts.bold(size: .title)
        totalValueLabel.textColor = themeColors.contentBackgroundText

        backgroundColor = themeColors.contentBackground
    }
}
extension OneOrderTotalContainer: OneOrderInterfacePart {
    public func update(by update: DishOrder) {
        totalValueLabel.setup(price: update.total, currency: update.currency)
    }
}
extension OneOrderTotalContainer: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        return 50
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
