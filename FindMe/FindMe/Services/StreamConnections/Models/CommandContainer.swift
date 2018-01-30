//
//  CommandContainer.swift
//  FindMe
//
//  Created by Алексей on 23.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class CommandContainer: Glossy {

    private struct Keys {
        public static let id = "Id"
        public static let command = "Command"
        public static let data = "Data"
    }

    public let id: String
    public let command: Commands
    public let data: JSON?

    //MARK: Glossy
    public required init?(json: JSON) {

        self.id = (Keys.id <~~ json)!
        self.command = (Keys.command <~~ json)!
        self.data = Keys.data <~~ json
    }
    public func toJSON() -> JSON? {
        return jsonify([
            Keys.id ~~> self.id,
            Keys.command ~~> self.command,
            Keys.data ~~> self.data
            ])
    }
}
extension CommandContainer {

    public func model<TModel: JSONDecodable>() -> TModel? {

        guard let model = data else {
            return nil
        }

        return TModel(json: model)
    }
}
