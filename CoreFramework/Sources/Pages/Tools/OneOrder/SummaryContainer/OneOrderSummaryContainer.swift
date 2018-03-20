//
//  OneOrderSummaryContainer.swift
//  CoreFramework
//
//  Created by Алексей on 13.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class OneOrderSummaryContainer: UITableViewCell {

    public static func create() -> OneOrderSummaryContainer {
        return UINib.instantiate(from: String.tag(OneOrderSummaryContainer.self), bundle: Bundle.coreFramework)
    }

    //UI
    @IBOutlet weak var completeAtLabel: UILabel!

    @IBOutlet weak var placeNameTitleLabel: UILabel!
    @IBOutlet weak var placeNameValueLabel: UILabel!

    @IBOutlet weak var statusTitleLabel: UILabel!
    @IBOutlet weak var statusValueLabel: UILabel!


    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    //Data
    private var order: DishOrder?

    public override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = themeColors.contentBackground

        let boldFont = themeFonts.bold(size: .subhead)
        let lightFont = themeFonts.default(size: .subhead)

        completeAtLabel.font = boldFont
        completeAtLabel.text = String.empty

        placeNameTitleLabel.font = lightFont
        placeNameTitleLabel.text = OneOrderController.Keys.placeNameTitleLabel.localized
        placeNameValueLabel.font = boldFont
        placeNameValueLabel.text = String.empty

        statusTitleLabel.font = lightFont
        statusTitleLabel.text = OneOrderController.Keys.statusTitleLabel.localized
        statusValueLabel.font = boldFont
        statusValueLabel.text = String.empty
    }
}
extension OneOrderSummaryContainer: OneOrderInterfacePart {
    public func update(by update: DishOrder) {
        self.order = update

        let format = OneOrderController.Keys.completeAtLabel.localized
        let time = formatter(OneOrderController.Keys.timeFormat.localized).string(from: update.summary.completeAt)
        let date = formatter(OneOrderController.Keys.dateFormat.localized).string(from: update.summary.completeAt)
        completeAtLabel.text = String(format: format, time, date)

        placeNameValueLabel.text = update.summary.placeName
        statusValueLabel.text = prepareStatus(update.status).localized
    }
    private func formatter(_ format: String) -> DateFormatter {

        let result = DateFormatter(for: format)
        result.timeZone = TimeZone.utc

        return result
    }
    private func prepareStatus(_ status: DishOrderStatus) -> Localizable {

        switch(status) {
            case .waitingPayment:
                return OneOrderController.Keys.statusWaitingPayment
            case .making:
                return OneOrderController.Keys.statusMaking
            case .prepared:
                return OneOrderController.Keys.statusPrepared
            case .completed:
                return OneOrderController.Keys.statusCompleted
            case .paymentFail:
                return OneOrderController.Keys.statusPaymentFail
            case .canceledByPlace:
                return OneOrderController.Keys.statusCanceledByPlace
            case .canceledByUser:
                return OneOrderController.Keys.statusCanceledByUser
            case .processing:
                fallthrough
            default:
                return OneOrderController.Keys.statusProcessing
        }
    }
}
extension OneOrderSummaryContainer: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return 92
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
