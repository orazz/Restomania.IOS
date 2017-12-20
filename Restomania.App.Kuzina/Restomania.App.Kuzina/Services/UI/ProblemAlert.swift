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

        let alert = UIAlertController(title: "Ошибка соединения", message: "Нет содинения с интрнетом. Попробуйте позднее.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        return alert
    }
    public static var internalError: UIAlertController {

        let alert = UIAlertController(title: "Ошибка", message: "У нас возникла ошибка, но мы скоро все исправим, попробуйте позднее.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        return alert
    }
}
