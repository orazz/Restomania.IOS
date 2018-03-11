//
//  EmailAuth.swift
//  UIServices
//
//  Created by Алексей on 05.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class EmailAuth {
    public enum Localization: String, Localizable {

        public var tableName: String {
            return String.tag(SignupController.self)
        }
        public var bundle: Bundle {
            return Bundle.coreFramework
        }

        case titleEnter = "Title.Enter"
        case titleResetPassword = "Title.ResetPassword"


        case alertsSuccessTitle = "Alerts.SuccessTitle"
        case alertsAuthTitle = "Alerts.AuthTitle"
        case alertsResetPasswordTitle = "Alerts.ResetPasswordTitle"
        case alertsNotCorrectEmail = "Alerts.NotCorrectEmail"
        case alertsNotCorrectPassword = "Alerts.NotCorrectPassword"
        case alertsNoConnection = "Alerts.NoConection"
        case alertsNotFoundByEmail = "Alerts.NotFoundByEmail"
        case alertsSameEmail = "Alerts.SameEmail"
        case alertSendResetPassword = "Alerts.SendResetPassword"
        case alertsNotValid = "Alerts.NotValidEmailOrPassword"
        case alertsPromlemOnServer = "Alerts.ProblemOnServer"
    }
}
