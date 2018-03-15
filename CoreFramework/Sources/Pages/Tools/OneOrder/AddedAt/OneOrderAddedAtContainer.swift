//
//  OneOrderAddedAtContainer.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 13.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class OneOrderAddedAtContainer: UITableViewCell {

    public static var instance: OneOrderAddedAtContainer {
        return UINib.instantiate(from: String.tag(OneOrderAddedAtContainer.self), bundle: Bundle.coreFramework)
    }

    //UI
    @IBOutlet private weak var createAtLabel: UILabel!

    //Theme
    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.contentDivider

        createAtLabel.text = String.empty
        createAtLabel.textColor = themeColors.contentDividerText
        createAtLabel.font = themeFonts.default(size: .caption)
    }
}
extension OneOrderAddedAtContainer: OneOrderInterfacePart {
    public func update(by update: DishOrder) {

        let format = OneOrderController.Keys.createAtLabel.localized
        let time = formatter(OneOrderController.Keys.timeFormat.localized).string(from: update.summary.createAt)
        let date = formatter(OneOrderController.Keys.dateFormat.localized).string(from: update.summary.createAt)
        createAtLabel.text = String(format: format, time, date)
    }
    private func formatter(_ format: String) -> DateFormatter {

        let result = DateFormatter(for: format)
        result.timeZone = TimeZone.utc

        return result
    }
}
extension OneOrderAddedAtContainer: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return 25
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
