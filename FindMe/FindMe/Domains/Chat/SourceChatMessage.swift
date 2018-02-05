//
//  SourceChatMessage.swift
//  FindMe
//
//  Created by Алексей on 23.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class SourceChatMessage: BaseDataType {

    private struct Keys {
        fileprivate static let senderId = "SenderId"
        fileprivate static let dialogId = "DialogId"
        fileprivate static let content = "Content"
        fileprivate static let attachment = "Attachment"
    }

    public var senderId: Long
    public var dialogId: Long
    public var content: String
    public var attachment: String?

    public override init() {

        self.senderId = 0
        self.dialogId = 0
        self.content = String.empty
        self.attachment = nil

        super.init()
    }
    public init(source: SourceChatMessage) {

        self.senderId = source.senderId
        self.dialogId = source.dialogId
        self.content = source.content
        self.attachment = source.attachment

        super.init(source: source)
    }

    //MARK: Glossy
    public required init(json: JSON) {

        self.senderId = (Keys.senderId <~~ json)!
        self.dialogId = (Keys.dialogId <~~ json)!
        self.content = (Keys.content <~~ json)!
        self.attachment = Keys.attachment <~~ json

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([

            Keys.senderId ~~> self.senderId,
            Keys.dialogId ~~> self.dialogId,
            Keys.content ~~> self.content,
            Keys.attachment ~~> self.attachment,

            super.toJSON()
            ])
    }
}
