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
    private var order: DishOrder!

    //Properties
    public var orderId: Long {
        return order.ID
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        let font = ThemeSettings.Fonts.default(size: .subhead)

        IdLabel.font = font
        DateLabel.font = font
        PlaceNameLabel.font = font
        PriceLabel.font = font
    }
    public func update(by order: DishOrder) {

        self.order = order

        IdLabel.text = String(format: ManagerOrdersController.Keys.idFormat.localized, orderId)
        DateLabel.text = formatter.string(from: order.summary.completeAt)
        PlaceNameLabel.text = order.summary.placeName
        PriceLabel.setup(amount: order.total.double, currency: order.currency)

        alpha = order.isCompleted ? 0.5 : 1.0
        for view in subviews {
            view.alpha = alpha
        }
    }

    private var formatter: DateFormatter {

        let result = DateFormatter()

        result.dateFormat = ManagerOrdersController.Keys.dateAndTimeFormat.localized
        result.timeZone = TimeZone.utc

        return result
    }
}
