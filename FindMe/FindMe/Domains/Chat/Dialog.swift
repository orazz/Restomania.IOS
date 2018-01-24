//
//  DialogModel.swift
//  FindMe
//
//  Created by Алексей on 24.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class Dialog: ICached {

    private struct Keys {
        fileprivate static let id = BaseDataType.Keys.ID
        fileprivate static let name = "Name"
        fileprivate static let isMute = "IsMute"
        fileprivate static let isBan = "IsBan"
        fileprivate static let lastMessage = "LastMessage"
        fileprivate static let partners = "Partners"
    }

    public let ID: Long
    public var name: String
    public var isMute: Bool
    public var isBan: Bool
    public var lastMessage: ChatMessage?
    public var partners: [PartnerStatus]

    public init() {

        self.ID = 0
        self.name = String.empty
        self.isMute = false
        self.isBan = false
        self.lastMessage = nil
        self.partners = []
    }

    //MARK: ICopying
    public required init(source: Dialog) {

        self.ID = source.ID
        self.name = source.name
        self.isMute = source.isMute
        self.isBan = source.isBan
        self.lastMessage = source.lastMessage
        self.partners = source.partners.map({ $0 })
    }

    //MARK: Glossy
    public required init?(json: JSON) {

        self.ID = (Keys.id <~~ json)!
        self.name = (Keys.name <~~ json)!
        self.isMute = (Keys.isMute <~~ json)!
        self.isBan = (Keys.isBan <~~ json)!
        self.lastMessage = Keys.lastMessage <~~ json
        self.partners = (Keys.partners <~~ json)!
    }
    public func toJSON() -> JSON? {
        return jsonify([

            Keys.id ~~> self.ID,
            Keys.name ~~> self.name,
            Keys.isMute ~~> self.isMute,
            Keys.isBan ~~> self.isBan,
            Keys.lastMessage ~~> self.lastMessage,
            Keys.partners ~~> self.partners,
            ])
    }
}
