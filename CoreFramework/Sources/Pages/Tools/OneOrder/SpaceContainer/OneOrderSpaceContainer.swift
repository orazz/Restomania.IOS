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
        return UINib.instantiate(from: nibName, bundle: Bundle.coreFramework)
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        let colors = DependencyResolver.resolve(ThemeColors.self)
        backgroundColor = colors.contentBackground
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
