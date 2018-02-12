//
//  UserNotificationPreference.swift
//  Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class UserNotificationPreference: BaseNotificationPreference {
    public var NewPaymentCard: Bool
    public var ChangeReviewStatus: Bool

    public override init() {
        self.NewPaymentCard = false
        self.ChangeReviewStatus = false

        super.init()
    }
    public required init(json: JSON) {
        self.NewPaymentCard = ("NewPaymentCard" <~~ json)!
        self.ChangeReviewStatus = ("ChangeReviewStatus" <~~ json)!

        super.init(json: json)
    }
}
