//
//  PingPongContainer.swift
//  FindMe
//
//  Created by Алексей on 24.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import Gloss

public class PingPongContainer: JSONDecodable {

    private struct Keys {
        fileprivate static let token = "Token"
        fileprivate static let needAnswer = "NeedAnswer"
    }

    public let token: String
    public let needAnswer: Bool

    public required init?(json: JSON) {

        self.token = (Keys.token <~~ json)!
        self.needAnswer = (Keys.needAnswer <~~ json)!
    }
}
