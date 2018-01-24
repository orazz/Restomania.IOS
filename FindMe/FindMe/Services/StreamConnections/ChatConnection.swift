//
//  ChatConnection.swift
//  FindMe
//
//  Created by Алексей on 23.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import SwiftR
import IOSLibrary

public protocol ChatConnectionDelegate {
    func chatConnection(_ connection: ChatConnection, new message: ChatMessage)
}
public class ChatConnection {

    private let tag = String.tag(ChatConnection.self)
    private let guid = Guid.new

    private let configs: ConfigsStorage
    private let keys: KeysStorage

    private let connection: SignalR

    public init(configs: ConfigsStorage, keys: KeysStorage) {

        self.configs = configs
        self.keys = keys

        self.connection = SignalR("\(configs.get(forKey: ConfigsKey.serverUrl))/connections")
        self.connection.addMessagesHandler()
    }

    public func start() {
        connection.start()
    }
}
extension ChatConnection: KeysStorageDelegate {
    public func set(keys: ApiKeys, for role: ApiRole) {}
    public func remove(for role: ApiRole) {}
}
extension SignalR {
    fileprivate func addMessagesHandler() {

//        let simpleHub = Hub("simpleHub")
//        simpleHub.on("notifySimple") { args in
//            let message = args![0] as! String
//            let detail = args![1] as! String
//            print("Message: \(message)\nDetail: \(detail)")
//        }
//
//        connection.addHub(simpleHub)
    }
}
