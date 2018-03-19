//
//  PlaceCartDivider.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class PlaceCartDivider: UITableViewCell {

    private static let nibName = String.tag(PlaceCartDivider.self)
    public static func create() -> PlaceCartDivider {
        return  UINib.instantiate(from: nibName, bundle: Bundle.coreFramework)
    }

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.contentBackground
    }
}
extension PlaceCartDivider: PlaceCartContainerCell {

    public func viewDidAppear() {}
    public func viewDidDisappear() {}
    public func updateData(with: PlaceCartDelegate) {}
}
extension PlaceCartDivider: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return 15
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
