//
//  DishModalShortDivider.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class DishModalShortDivider: UITableViewCell {

    public static func create(for content: InterfaceTableCellProtocol) -> DishModalShortDivider {

        let cell: DishModalShortDivider = UINib.instantiate(from: "\(String.tag(DishModalShortDivider.self))View", bundle: Bundle.main)
        cell.content = content

        return cell
    }

    //UI
    @IBOutlet private var dividerView: UIView!

    //Data
    private var content: InterfaceTableCellProtocol?

    public override func awakeFromNib() {
        super.awakeFromNib()

        dividerView.backgroundColor = ThemeSettings.Colors.main
    }
}
extension DishModalShortDivider: DishModalElementsProtocol {
}
extension DishModalShortDivider: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        if (content?.viewHeight == 0) {
            return 0
        } else {
            return 11
        }
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
