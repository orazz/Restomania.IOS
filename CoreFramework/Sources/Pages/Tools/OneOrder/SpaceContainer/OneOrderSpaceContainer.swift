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

    public static func create() -> OneOrderSpaceContainer {
        return UINib.instantiate(from: String.tag(OneOrderSpaceContainer.self), bundle: Bundle.coreFramework)
    }

    private let themeColors = DependencyResolver.resolve(ThemeColors.self)

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.contentDivider
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
