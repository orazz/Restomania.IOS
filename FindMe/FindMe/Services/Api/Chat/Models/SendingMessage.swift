//
//  SendingMessage.swift
//  FindMe
//
//  Created by Алексей on 24.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import IOSLibrary

public class SendingMessage: JSONEncodable {

    private struct Keys {
        fileprivate static let dialogId = "DialogId"
        fileprivate static let content = "Content"
        fileprivate static let attachment = "Attachment"
    }

    public let dialogId: Long
    public let content: String
    public var attachment: String?

    public init(toDialog dialogId: Long, content: String, attachment: String? = nil) {

        self.dialogId = dialogId
        self.content = content
        self.attachment = attachment
    }

    public func createStub() -> ChatMessage {

        let source = SourceChatMessage()
        source.senderId = -1
        source.dialogId = dialogId
        source.content = content
        source.attachment = nil

        return ChatMessage(wrap: source)
    }

    //MARK: Glossy
    public func toJSON() -> JSON? {
        return jsonify([

            Keys.dialogId ~~> self.dialogId,
            Keys.content ~~> self.content,
            Keys.attachment ~~> self.attachment,
            ])
    }
}
