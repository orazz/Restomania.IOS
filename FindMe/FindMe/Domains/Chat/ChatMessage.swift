//
//  ChatMessage.swift
//  FindMe
//
//  Created by Алексей on 24.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import Gloss

public class ChatMessage: SourceChatMessage, ICached {

    private struct Keys {
        fileprivate static let sourceMessageId = "SourceMessageId"
        fileprivate static let recipientId = "RecipientId"
        fileprivate static let deliveryStatus = "DeliveryStatus"
    }

    public let sourceMessageId: Long
    public let recipientId: Long
    public var deliveryStatus: DeliveryStatus

    public override init() {

        self.sourceMessageId = 0
        self.recipientId = 0
        self.deliveryStatus = .processing

        super.init()
    }

    public init(wrap source: SourceChatMessage) {

        self.sourceMessageId = source.ID
        self.recipientId = -1
        self.deliveryStatus = .processing

        super.init(source: source)
    }

    public var isSended: Bool {
        return -1 == recipientId
    }

    //MARK: ICopying
    public required init(source: ChatMessage) {

        self.sourceMessageId = source.sourceMessageId
        self.recipientId = source.recipientId
        self.deliveryStatus = source.deliveryStatus

        super.init(source: source)
    }

    //MARK: Glossy
    public required init(json: JSON) {

        self.sourceMessageId = (Keys.sourceMessageId <~~ json)!
        self.recipientId = (Keys.recipientId <~~ json)!
        self.deliveryStatus = (Keys.deliveryStatus <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([

            Keys.sourceMessageId ~~> self.sourceMessageId,
            Keys.recipientId ~~> self.recipientId,
            Keys.deliveryStatus ~~> self.deliveryStatus,

            super.toJSON()
            ])
    }
}
