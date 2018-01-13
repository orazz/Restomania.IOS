//
//  OneOrderSummaryContainer.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 13.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class OneOrderSummaryContainer: UITableViewCell {

    private static var nibName = "\(String.tag(OneOrderSummaryContainer.self))View"
    public static var instance: OneOrderSummaryContainer {

        let cell: OneOrderSummaryContainer = UINib.instantiate(from: nibName, bundle: Bundle.main)

        cell.loadStyles()

        return cell
    }

    //UI
    @IBOutlet weak var completeAtLabel: UILabel!

    @IBOutlet weak var codewordTitleLabel: UILabel!
    @IBOutlet weak var codeworddValueLabel: UILabel!

    @IBOutlet weak var placeNameTitleLabel: UILabel!
    @IBOutlet weak var placeNameValueLabel: UILabel!

    @IBOutlet weak var statusTitleLabel: UILabel!
    @IBOutlet weak var statusValueLabel: UILabel!

    //Data
    private var order: DishOrder?

    private func loadStyles() {
        backgroundColor = ThemeSettings.Colors.main

        let boldFont = ThemeSettings.Fonts.bold(size: .head)
        let lightFont = ThemeSettings.Fonts.default(size: .head)

        completeAtLabel.font = boldFont
        completeAtLabel.text = String.empty

        codewordTitleLabel.font = lightFont
        codewordTitleLabel.text = OneOrderController.Keys.codewordTitleLabel.localized
        codeworddValueLabel.font = boldFont
        codeworddValueLabel.text = String.empty

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

        codeworddValueLabel.text = update.summary.codeword

        placeNameValueLabel.text = update.summary.placeName

        statusValueLabel.text = prepareStatus(update.status).localized
    }
    private func formatter(_ format: String) -> DateFormatter {

        let result = DateFormatter()

        result.dateFormat = format
        result.timeZone = TimeZone(identifier: "UTC")

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
        return 135
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
