//
//  OrderCell.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 11.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class ManagerOrdersControllerViewOrderCell: UITableViewCell {

    public static let identifier = "OrderCell-\(Guid.new)"
    public static let nibName = "ManagerOrdersControllerViewOrderCellView"
    public static let height: CGFloat = 70

    //UIELements
    @IBOutlet weak var IdLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var PlaceNameLabel: UILabel!
    @IBOutlet weak var PriceLabel: PriceLabel!

    //Data
    public var OrderId: Long {

        return _order.ID
    }
    private var _order: DishOrder!
    private var _delegate: OrdersControllerProtocol!
    private var _isSetupMarkup: Bool = false
    private var _dateFormatter: DateFormatter {

        let result = DateFormatter()

        result.dateFormat = "\(AppSummary.DataTimeFormat.shortTime)\n\(AppSummary.DataTimeFormat.shortDate)"
        result.timeZone = TimeZone(identifier: "UTC")

        return result
    }

    public func setup(order: DishOrder, delegate: OrdersControllerProtocol) {

        setupStyles()

        _order = order
        _delegate = delegate

        IdLabel.text = "# \(OrderId)"
        DateLabel.text = _dateFormatter.string(from: order.Summary.CompleteDate)
        PlaceNameLabel.text = order.Summary.PlaceName
        PriceLabel.setup(amount: order.TotalPrice, currency: order.Summary.Currency)
    }
    private func setupStyles() {

        if (_isSetupMarkup) {

            return
        }

        let font = ThemeSettings.Fonts.default(size: .subhead)

        IdLabel.font = font
        DateLabel.font = font
        PlaceNameLabel.font = font
        PriceLabel.font = font

        _isSetupMarkup = true
    }
}
