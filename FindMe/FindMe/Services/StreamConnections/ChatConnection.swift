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
    public private(set) var isConnected: Bool = false

    private let configs: ConfigsStorage
    private let keys: KeysStorage
    fileprivate let eventsAdapter: EventsAdapter<ChatConnectionDelegate>

    fileprivate let connection: SignalR
    fileprivate let chatHub: Hub

    public init(configs: ConfigsStorage, keys: KeysStorage) {

        self.configs = configs
        self.keys = keys
        self.eventsAdapter = EventsAdapter<ChatConnectionDelegate>(tag: tag)


        let url = configs.get(forKey: ConfigsKey.serverUrl).value as! String
        self.connection = SignalR("\(url)/connections")
        self.chatHub = Hub("ChatHub")

        self.addPingPingHandler()
        self.addMessagesHandler()
        connection.addHub(self.chatHub)


        keys.subscribe(guid: guid, handler: self, tag: tag)
    }

    public func start() {

        guard let keys = self.keys.keys(for: .user) else {
            return
        }
        
        isConnected = true
        var query = String.empty
        do {
            let data = try JSONSerialization.data(withJSONObject: keys.toJSON()!, options: [])
            query = String(data: data, encoding: .utf8)!
        }
        catch {}

        DispatchQueue.main.async {
            self.connection.queryString = ["keys": query]

            self.connection.error = { error in
                print("Error: \(error)")
            }
            self.connection.connected = {
                print("Fuck")
            }

            self.connection.start()
        }
    }
    public func stop() {

        if (isConnected) {
            isConnected = false
            DispatchQueue.main.async {
                self.connection.stop()
            }
        }
    }
    public func restart() {
        stop()
        start()
    }
}
extension ChatConnection: KeysStorageDelegate {
    public func set(keys: ApiKeys, for role: ApiRole) {
        if (role == .user) {
            restart()
        }
    }
    public func remove(for role: ApiRole) {
        if (role == .user) {
            restart()
        }
    }
}
extension ChatConnection {
    fileprivate func addPingPingHandler() {

        chatHub.on("PingPong") { args in

        }
    }
    fileprivate func addMessagesHandler() {

        chatHub.on("Messages") { args in
            print("Message processing: \(String(describing: args))")
        }

    }
}
