//
//  SimpleDialogMessageModel.swift
//  FindMe
//
//  Created by Алексей on 06.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class SimpleDialogMessageModel: DialogMessageModelProtocol {

    public var id: Long {
        return source.ID
    }
    public var content: String {
        return source.content
    }
    public var createAt: Date {
        return source.CreateAt
    }
    public var deliveryStatus: DeliveryStatus {
        return source.deliveryStatus
    }
    public var isOutgoing: Bool {
        return source.isOutgoing
    }

    private var source: ChatMessage

    public init(for message: ChatMessage) {

        self.source = message
    }

    public func update(by value: ChatMessage) {
        self.source = value
    }
    public func buildMessage() -> ChatMessage {
        return source
    }
}
