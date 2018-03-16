//
//  ProblemAlert.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 19.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class ProblemAlerts {

    public static func error<TType>(for response: ApiResponse<TType>) -> UIAlertController {
        return error(for: response.statusCode)
    }
    public static func error(for code: HttpStatusCode) -> UIAlertController {

        switch code {
        case .ConnectionError:
            return noConnection
        default:
            return internalError
        }
    }

    public static var noConnection: UIAlertController {
        return toastAlert(title: Localization.titlesConnectionError,
                          message: Localization.messageNoConnection)
    }
    public static var internalError: UIAlertController {
        return toastAlert(title: Localization.titlesError,
                          message: Localization.messageServerError)
    }
    public static func toastAlert(title: Localizable, message: Localizable) -> UIAlertController {
        return toastAlert(title: title.localized, message: message.localized)
    }
    public static func toastAlert(title: String, message: String) -> UIAlertController {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Localization.buttonsOk.localized, style: .cancel, handler: nil))

        return alert
    }
}
extension ProblemAlerts {
    fileprivate enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(ProblemAlerts.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        case titlesError = "Titles.Error"
        case titlesConnectionError = "Titles.ConnectionError"

        case messageNoConnection = "Messages.NoConnection"
        case messageServerError = "Messages.ServerError"

        case buttonsOk = "Buttons.Ok"
    }
}

extension UIViewController {

    open func alert<T>(about response: ApiResponse<T>, complettion: Trigger? = nil) {

        let alert = ProblemAlerts.error(for: response)
        self.present(alert, animated: true, completion: complettion)
    }
}
