//
//  DialogModel.swift
//  FindMe
//
//  Created by Алексей on 24.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import Gloss

public class ChatDialog: ICached {

    private struct Keys {
        fileprivate static let id = BaseDataType.Keys.ID
        fileprivate static let recipientId = "RecipientId"

        fileprivate static let name = "Name"
        fileprivate static let logo = "Logo"
        fileprivate static let isMute = "IsMute"
        fileprivate static let isBan = "IsBan"
        fileprivate static let isGroup = "IsGroup"
        fileprivate static let lastMessage = "LastMessage"
        fileprivate static let lastActivity = "LastActivity"
        fileprivate static let partners = "Partners"
    }

    public let ID: Long
    public let recipientId: Long

    public var name: String
    public var logo: String
    public var isMute: Bool
    public var isBan: Bool
    public var isGroup: Bool
    public var lastMessage: ChatMessage?
    public var lastActivity: Date
    public var partners: [PartnerStatus]

    public init() {

        self.ID = 0
        self.recipientId = 0

        self.name = String.empty
        self.logo = String.empty
        self.isMute = false
        self.isBan = false
        self.isGroup = false
        self.lastMessage = nil
        self.lastActivity = Date()
        self.partners = []
    }

    //MARK: ICopying
    public required init(source: ChatDialog) {

        self.ID = source.ID
        self.recipientId = source.recipientId

        self.name = source.name
        self.logo = source.logo
        self.isMute = source.isMute
        self.isBan = source.isBan
        self.isGroup = source.isBan
        self.lastMessage = source.lastMessage
        self.lastActivity = source.lastActivity
        self.partners = source.partners.map({ $0 })
    }

    //MARK: Glossy
    public required init?(json: JSON) {

        self.ID = (Keys.id <~~ json)!
        self.recipientId = (Keys.recipientId <~~ json)!

        self.name = (Keys.name <~~ json)!
        self.logo = (Keys.logo <~~ json)!
        self.isMute = (Keys.isMute <~~ json)!
        self.isBan = (Keys.isBan <~~ json)!
        self.isGroup = (Keys.isGroup <~~ json)!
        self.lastMessage = Keys.lastMessage <~~ json

        let date: String = (Keys.lastActivity <~~ json)!
        self.lastActivity = Date.parseJson(value: date)
        
        self.partners = (Keys.partners <~~ json)!
    }
    public func toJSON() -> JSON? {
        return jsonify([

            Keys.id ~~> self.ID,
            Keys.recipientId ~~> self.recipientId,

            Keys.name ~~> self.name,
            Keys.logo ~~> self.logo,
            Keys.isMute ~~> self.isMute,
            Keys.isBan ~~> self.isBan,
            Keys.isGroup ~~> self.isGroup,
            Keys.lastMessage ~~> self.lastMessage,
            Keys.lastActivity ~~> self.lastActivity.prepareForJson(),
            Keys.partners ~~> self.partners
            ])
    }
}
