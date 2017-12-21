//
//  ProblemAlert.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 19.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

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

        let title = Localization.UIElements.ProblemAlerts.connectionErrorTitle
        let message = Localization.UIElements.ProblemAlerts.noConnectionMessage

        return toastAlert(title: title, message: message)
    }
    public static var internalError: UIAlertController {

        let title = Localization.UIElements.ProblemAlerts.errorTitle
        let message = Localization.UIElements.ProblemAlerts.serverErrorMessage

        return toastAlert(title: title, message: message)
    }
    public static func toastAlert(title: Localizable, message: Localizable) -> UIAlertController {
        return toastAlert(title: title.localized, message: message.localized)
    }
    public static func toastAlert(title: String, message: String) -> UIAlertController {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Localization.UIElements.ProblemAlerts.okAction, style: .cancel, handler: nil))

        return alert
    }
}

extension UIViewController {

    public func toast(title: Localizable, message: Localizable, complettion: Trigger? = nil) {
        self.toast(title: title.localized, message: message.localized, completion: complettion)
    }
    public func toast(title: String, message: String, completion: Trigger? = nil) {

        let alert = ProblemAlerts.toastAlert(title: title, message: message)

        self.present(alert, animated: true, completion: completion)
    }
}
