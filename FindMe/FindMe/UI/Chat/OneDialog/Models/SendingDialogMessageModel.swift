//
//  SendingDialogMessageModel.swift
//  FindMe
//
//  Created by Алексей on 06.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class SendingDialogMessageModel: DialogMessageModelProtocol {

    public private(set) var id: Long
    public var content: String {
        return source.content
    }
    public private(set) var createAt: Date
    public var deliveryStatus: DeliveryStatus {
        return .sending
    }
    public var isOutgoing: Bool {
        return true
    }

    private var source: SendingMessage

    public init(for message: SendingMessage, id: Long) {

        self.id = id
        self.createAt = Date()
        self.source = message
    }

    public func update(by value: ChatMessage) {}
    public func buildMessage() -> ChatMessage {

        var result = ChatMessage()

        result.content = source.content
        result.CreateAt = createAt
        result.markLikeOutgoing()

        return result
    }
}
