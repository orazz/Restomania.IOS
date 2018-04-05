//
//  PlaceCartDivider.swift
//  CoreFramework
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

        backgroundColor = themeColors.divider
    }
}
//extension PlaceCartDivider: PlaceCartElement {
//
//    public func viewDidAppear() {}
//    public func viewDidDisappear() {}
//    public func update(with: PlaceCartDelegate) {}
//    public func height() -> CGFloat {
//        return 15
//    }
//}
