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
        fileprivate static let attachments = "Attachments"
    }

    public let dialogId: Long
    public let content: String
    public var attachments: [Long]

    public init(to dialogId: Long, with content: String, and attachments: [Long]) {

        self.dialogId = dialogId
        self.content = content
        self.attachments = attachments
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
