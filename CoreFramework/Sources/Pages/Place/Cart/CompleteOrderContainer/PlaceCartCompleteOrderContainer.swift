//
//  PlaceCartCompleteOrderContainer.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class PlaceCartCompleteOrderContainer: UITableViewCell {

    private static let nibName = "\(String.tag(PlaceCartCompleteOrderContainer.self))View"
    public static func create(for delegate: PlaceCartDelegate) -> PlaceCartCompleteOrderContainer {

        let nib = UINib(nibName: nibName, bundle: Bundle.coreFramework)
        let cell = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceCartCompleteOrderContainer

        cell.delegate = delegate

        return cell
    }

    //UI hooks
    @IBOutlet private weak var titleLabel: UILabel!

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    //Data
    private var delegate: PlaceCartDelegate!

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.actionMain

        titleLabel.font = themeFonts.default(size: .title)
        titleLabel.textColor = themeColors.actionContent
        titleLabel.text = PlaceCartController.Localization.Buttons.addNewOrder.localized.uppercased()
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
