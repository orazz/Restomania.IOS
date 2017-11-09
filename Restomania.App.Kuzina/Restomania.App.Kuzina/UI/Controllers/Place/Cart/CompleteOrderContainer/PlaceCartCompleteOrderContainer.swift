//
//  PlaceCartCompleteOrderContainer.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class PlaceCartCompleteOrderContainer: UITableViewCell {

    private static let nibName = "PlaceCartCompleteOrderContainerView"
    public static func create(for delegate: PlaceCartDelegate) -> PlaceCartCompleteOrderContainer {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let cell = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceCartCompleteOrderContainer

        cell.delegate = delegate
        cell.setupMarkup()

        return cell
    }

    //UI hooks
    @IBOutlet private weak var titleLabel: UILabel!

    //Data
    private var delegate: PlaceCartDelegate!

    private func setupMarkup() {

        self.backgroundColor = ThemeSettings.Colors.main

        titleLabel.font = ThemeSettings.Fonts.default(size: .title)
        titleLabel.textColor = ThemeSettings.Colors.additional
    }
}
extension PlaceCartCompleteOrderContainer: PlaceCartContainerCell {
    public func viewDidAppear() {}
    public func viewDidDisappear() {}
    public func updateData(with: PlaceCartDelegate) {}
}
extension PlaceCartCompleteOrderContainer: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        return 50
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
    public func select(with: UINavigationController) {
        delegate.tryAddOrder()
    }
}
