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

public class ManagerOrdersControllerOrderCell: UITableViewCell {

    public static let identifier = "OrderCell-\(Guid.new)"
    public static let height: CGFloat = 70
    private static let nibName = "ManagerOrdersControllerOrderCellView"
    public static func register(in tableView: UITableView) {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }

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

        var alpha = 1.0
        if (_order.isCompleted) {
            alpha = 0.5
        }
        for view in subviews {
            view.alpha = CGFloat(alpha)
        }
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
