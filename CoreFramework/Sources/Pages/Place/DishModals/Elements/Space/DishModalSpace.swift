//
//  DishModalSpace.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class DishModalSpace: UITableViewCell {

    public static func create() -> DishModalSpace {

        let nibname = String.tag(DishModalSpace.self)
        return UINib.instantiate(from: nibname, bundle: Bundle.coreFramework)
    }

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.divider
    }
}
extension DishModalSpace: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        return 30
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
