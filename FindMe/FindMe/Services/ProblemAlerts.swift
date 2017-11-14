//
//  ProblemAlerts.swift
//  FindMe
//
//  Created by Алексей on 14.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class ProblemAlerts {

    public static func Error(for code: HttpStatusCode) -> UIAlertController {

        switch code {
        case .ConnectionError:
            return NotConnection
        default:
            return InternalError
        }
    }

    public static var NotConnection: UIAlertController {

        let alert = UIAlertController(title: "Ошибка соединения", message: "Нет содинения с интрнетом. Попробуйте позднее.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        return alert
    }
    public static var InternalError: UIAlertController {

        let alert = UIAlertController(title: "Ошибка", message: "У нас возникла ошибка, но мы скоро все исправим, попробуйте позднее.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        return alert
    }
}
