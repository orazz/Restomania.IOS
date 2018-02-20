//
//  OneOrderFooterContainer.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 13.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import CoreDomains

public class OneOrderFooterContainer: UITableViewCell {

    private static var nibName = "\(String.tag(OneOrderFooterContainer.self))View"
    public static var instance: OneOrderFooterContainer {

        let cell: OneOrderFooterContainer = UINib.instantiate(from: nibName, bundle: Bundle.main)

        return cell
    }

    //UI
    @IBOutlet private weak var createAtLabel: UILabel!

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = ThemeSettings.Colors.background

        createAtLabel.text = String.empty
        createAtLabel.font = ThemeSettings.Fonts.default(size: .subhead)
    }
}
extension OneOrderFooterContainer: OneOrderInterfacePart {
    public func update(by update: DishOrder) {

        let format = OneOrderController.Keys.createAtLabel.localized
        let time = formatter(OneOrderController.Keys.timeFormat.localized).string(from: update.summary.CreateAt)
        let date = formatter(OneOrderController.Keys.dateFormat.localized).string(from: update.summary.CreateAt)
        createAtLabel.text = String(format: format, time, date)
    }
    private func formatter(_ format: String) -> DateFormatter {

        let result = DateFormatter(for: format)
        result.timeZone = TimeZone.utc

        return result
    }
}
extension OneOrderFooterContainer: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return 25
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
