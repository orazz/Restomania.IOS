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

    private static let nibName = "PlaceCartDividerView"
    public static func create() -> PlaceCartDivider {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let cell = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceCartDivider

        cell.setupMarkup()

        return cell
    }

    private func setupMarkup() {
        self.backgroundColor = ThemeSettings.Colors.background
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
