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
    @IBOutlet weak var CompleteAtLabel: UILabel!

    @IBOutlet weak var CodewordTitleLabel: UILabel!
    @IBOutlet weak var CodeworddValueLabel: UILabel!

    @IBOutlet weak var PlaceNameTitleLabel: UILabel!
    @IBOutlet weak var PlaceNameValueLabel: UILabel!

    @IBOutlet weak var StatusTitleLabel: UILabel!
    @IBOutlet weak var StatusValueLabel: UILabel!

    //Data
    private var order: DishOrder?

    private func loadStyles() {
        backgroundColor = ThemeSettings.Colors.main

        let boldFont = ThemeSettings.Fonts.bold(size: .head)
        let lightFont = ThemeSettings.Fonts.default(size: .head)

        CompleteAtLabel.font = boldFont
        CompleteAtLabel.text = String.empty

        CodewordTitleLabel.font = lightFont
        CodewordTitleLabel.text = OneOrderController.Keys.codewordTitleLabel.localized
        CodeworddValueLabel.font = boldFont
        CodeworddValueLabel.text = String.empty

        PlaceNameTitleLabel.font = lightFont
        PlaceNameTitleLabel.text = OneOrderController.Keys.placeNameTitleLabel.localized
        PlaceNameValueLabel.font = boldFont
        PlaceNameValueLabel.text = String.empty

        StatusTitleLabel.font = lightFont
        StatusTitleLabel.text = OneOrderController.Keys.statusTitleLabel.localized
        StatusValueLabel.font = boldFont
        StatusValueLabel.text = String.empty
    }
}
extension OneOrderSummaryContainer: OneOrderInterfacePart {
    public func update(by update: DishOrder) {
        self.order = update

        let format = OneOrderController.Keys.completeAtLabel.localized
        let time = formatter(OneOrderController.Keys.timeFormat.localized).string(from: update.summary.completeAt)
        let date = formatter(OneOrderController.Keys.dateFormat.localized).string(from: update.summary.completeAt)
        CompleteAtLabel.text = String(format: format, time, date)

        CodeworddValueLabel.text = update.summary.codeword

        PlaceNameValueLabel.text = update.summary.placeName

        StatusValueLabel.text = prepareStatus(update.status).localized
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
