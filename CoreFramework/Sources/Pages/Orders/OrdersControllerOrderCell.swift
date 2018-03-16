//
//  OrdersControllerOrderCell.swift
//  CoreFramework
//
//  Created by Алексей on 11.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class OrdersControllerOrderCell: UITableViewCell {

    public static let identifier = Guid.new
    public static func register(in tableView: UITableView) {

        let nib = UINib(nibName: String.tag(OrdersControllerOrderCell.self), bundle: Bundle.coreFramework)
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }

    //UIELements
    @IBOutlet private weak var IdLabel: UILabel!
    @IBOutlet private weak var DateLabel: UILabel!
    @IBOutlet private weak var PlaceNameLabel: UILabel!
    @IBOutlet private weak var PriceLabel: PriceLabel!

    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    //Data
    private var order: DishOrder!

    //Properties
    public var orderId: Long {
        return order.id
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.contentBackground

        let color = themeColors.contentText

        IdLabel.font = themeFonts.bold(size: .title)
        IdLabel.textColor = color

        DateLabel.font = themeFonts.default(size: .subhead)
        DateLabel.textColor = color

        PlaceNameLabel.font = themeFonts.default(size: .caption)
        PlaceNameLabel.textColor = color

        PriceLabel.font = themeFonts.bold(size: .subhead)
        PriceLabel.textColor = color
    }
    public func update(by order: DishOrder) {

        self.order = order

        let idValue = String(format: OrdersController.Keys.idFormat.localized, orderId)
        IdLabel.text = idValue
        IdLabel.setContraint(width: idValue.width(containerHeight: IdLabel.frame.height, font: IdLabel.font!))


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

        result.dateFormat = OrdersController.Keys.dateAndTimeFormat.localized
        result.timeZone = TimeZone.utc

        return result
    }
}
