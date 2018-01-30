//
//  ChangeMessageStatus.swift
//  FindMe
//
//  Created by Алексей on 24.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import IOSLibrary

public class ChangeMessageStatus: JSONDecodable {

    private struct Keys {
        fileprivate static let id = BaseDataType.Keys.ID
        fileprivate static let deliveryStatus = "DeliveryStatus"
    }

    public let id: Long
    public let deliveryStatus: DeliveryStatus

    //MARK: Glossy
    public required init?(json: JSON) {

        self.id = (Keys.id <~~ json)!
        self.deliveryStatus = (Keys.deliveryStatus <~~ json)!
    }
}
