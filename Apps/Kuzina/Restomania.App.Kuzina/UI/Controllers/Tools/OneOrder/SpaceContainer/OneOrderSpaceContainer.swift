//
//  OneOrderSpaceContainer.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 13.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class OneOrderSpaceContainer: UITableViewCell {

    private static var nibName = "\(String.tag(OneOrderSpaceContainer.self))View"
    public static func create() -> OneOrderSpaceContainer {

        let cell: OneOrderSpaceContainer = UINib.instantiate(from: nibName, bundle: Bundle.main)

        cell.loadStyles()

        return cell
    }

    private func loadStyles() {
        backgroundColor = ThemeSettings.Colors.background
    }
}
extension OneOrderSpaceContainer: OneOrderInterfacePart {
    public func update(by: DishOrder) {}
}
extension OneOrderSpaceContainer: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return 20
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
