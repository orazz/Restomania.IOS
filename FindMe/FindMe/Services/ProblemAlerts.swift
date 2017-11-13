//
//  ProblemAlerts.swift
//  FindMe
//
//  Created by Алексей on 14.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public class ProblemAlerts {

    public static var NotConnection: UIAlertController {

        let alert = UIAlertController(title: "Ошибка соединения", message: "Нет содинения с интрнетом. Попробуйте позднее.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        return alert
    }
}
