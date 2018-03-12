//
//  OrderPushModel.swift
//  CoreFramework
//
//  Created by Алексей on 12.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class OrderPushModel: JSONDecodable {

    private struct Keys {
        fileprivate static let id = "ID"
        fileprivate static let status = "Status"
    }

    public let id: Long
    public let status: DishOrderStatus

    public init(_ id: Long, with status: DishOrderStatus) {
        
        self.id = id
        self.status = status
    }
    public required init?(json: JSON) {
        
        self.id = (Keys.id <~~ json)!
        self.status = (Keys.status <~~ json)!
    }
}
