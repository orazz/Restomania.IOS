//
//  DialogMessageModelProtocol.swift
//  FindMe
//
//  Created by Алексей on 06.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public protocol DialogMessageModelProtocol {

    var id: Long { get }
    var content: String { get }
    var createAt: Date { get }
    var deliveryStatus: DeliveryStatus { get }

    var isOutgoing: Bool { get }

    func update(by value: ChatMessage)
    func buildMessage() -> ChatMessage
}
fileprivate var timeFormatter = DateFormatter(for: "HH:mm")
extension DialogMessageModelProtocol {

    public var formattedCreateAt: String {
        return timeFormatter.string(from: self.createAt)
    }
}
