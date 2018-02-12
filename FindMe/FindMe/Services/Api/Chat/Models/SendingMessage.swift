//
//  SendingMessage.swift
//  FindMe
//
//  Created by Алексей on 24.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class SendingMessage: JSONEncodable {

    private struct Keys {
        fileprivate static let dialogId = "DialogId"
        fileprivate static let content = "Content"
        fileprivate static let attachments = "Attachments"
    }

    public let dialogId: Long
    public let content: String
    public var attachments: [String]

    public init(toDialog dialogId: Long, content: String, attachments: [String] = []) {

        self.dialogId = dialogId
        self.content = content
        self.attachments = attachments
    }

    public func createStub() -> ChatMessage {

        let source = SourceChatMessage()
        source.senderId = -1
        source.dialogId = dialogId
        source.content = content
        source.attachments = []

        return ChatMessage(wrap: source)
    }

    //MARK: Glossy
    public func toJSON() -> JSON? {
        return jsonify([

            Keys.dialogId ~~> self.dialogId,
            Keys.content ~~> self.content,
            Keys.attachments ~~> self.attachments,
            ])
    }
}
