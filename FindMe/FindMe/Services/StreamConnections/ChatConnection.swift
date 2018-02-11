//
//  ChatConnection.swift
//  FindMe
//
//  Created by Алексей on 23.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import SwiftR
import MdsKit

public class ChatConnection {

    private let tag = String.tag(ChatConnection.self)
    private let guid = Guid.new

    private let configs: ConfigsStorage
    private let keys: KeysStorage
    fileprivate let eventsAdapter: EventsAdapter<ChatConnectionDelegate>

    fileprivate let connection: SignalR
    fileprivate let chatHub: Hub
    private let pingPongInterval = 60.0
    private var pingPingTimer: Timer?
    private var pingPingTokens = [String]()

    public init(configs: ConfigsStorage, keys: KeysStorage) {

        self.configs = configs
        self.keys = keys
        self.eventsAdapter = EventsAdapter<ChatConnectionDelegate>(tag: tag)


        let url: String = configs.get(forKey: ConfigsKey.serverUrl)!
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

        do {
            let data = try JSONSerialization.data(withJSONObject: keys.toJSON()!, options: [])

            DispatchQueue.main.async {
                self.connection.queryString = ["keys": String(data: data, encoding: .utf8)!]
            }
        }
        catch {}

        DispatchQueue.main.async {
            self.pingPingTimer?.invalidate()
            self.pingPingTimer = nil
            self.pingPingTimer = Timer.scheduledTimer(timeInterval: self.pingPongInterval,
                                                      target: self,
                                                      selector: #selector(ChatConnection.refreshSession),
                                                      userInfo: nil,
                                                      repeats: true)
        }

        connection.disconnected = {

            Log.warning(self.tag, "Stream disconnected.")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5)) {
                self.connection.start()
            }
        }
        connection.connected = {
            Log.info(self.tag, "Stream connected.")
        }

        Log.debug(self.tag, "Launch chat stream connection.")
        DispatchQueue.main.async {
            self.connection.start()
        }
    }
    public func stop() {

        pingPingTimer?.invalidate()
        pingPingTimer = nil

        if (connection.state == .connected) {
            DispatchQueue.main.async {
                self.connection.stop()
            }
        }
    }
    public func restart() {
        stop()
        start()
    }

    @objc func refreshSession() {

        Log.debug(tag, "Send ping pong message.")

        let token = Guid.new
        pingPingTokens.append(token)
        sendPingPong(with: token, needAnswer: true)
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
extension ChatConnection: IEventsEmitter {
    public typealias THandler = ChatConnectionDelegate

    public func subscribe(guid: String, handler: ChatConnection.THandler, tag: String) {
        eventsAdapter.subscribe(guid: guid, handler: handler, tag: tag)
    }
    public func unsubscribe(guid: String) {
        eventsAdapter.unsubscribe(guid: guid)
    }
}
extension ChatConnection {
    fileprivate func addPingPingHandler() {

        chatHub.on("PingPong") { args in

            guard let container = self.tryParseArgs(args),
                let model: PingPongContainer = container.model() else {
                Log.warning(self.tag, "Problem with parse data.")
                return
            }



            if let index = self.pingPingTokens.index(where: { $0 == model.token }) {
                Log.debug(self.tag, "Server confirm connection.")
                self.pingPingTokens.remove(at: index)
            }
            else if (model.needAnswer) {
                Log.debug(self.tag, "Resendr server ping pings.")
                self.sendPingPong(with: model.token, needAnswer: false)
            }
        }
    }
    fileprivate func sendPingPong(with token: String, needAnswer: Bool) {

        DispatchQueue.main.async {
            do {
                try self.chatHub.invoke("PingPong", arguments: [token, needAnswer], callback: nil)
            }
            catch {}
        }
    }
    fileprivate func addMessagesHandler() {

        chatHub.on("Messages") { args in

            guard let container = self.tryParseArgs(args) else {
                Log.warning(self.tag, "Problem with parse message data.")
                return
            }



            if container.command == .newMessage,
                let model: ChatMessage = container.model() {

                self.eventsAdapter.invoke({ $0.chatConnection(self, new: model) })
                Log.info(self.tag, "Process new message.")
            }
            else if container.command == .newMessage,
                let model: ChangeMessageStatus = container.model() {

                self.eventsAdapter.invoke({ $0.chatConnection(self, message: model.id, changeStatusOn: model.deliveryStatus) })
                Log.info(self.tag, "Process change status of message.")
            }
        }
    }
    private func tryParseArgs(_ args: [Any]?) -> CommandContainer? {

        guard let json = args?.first as? String,
              let data = json.data(using: .utf8) else {
            return nil
        }

        do {
            return try JSONSerialization.parse(data: data)
        }
        catch {
            return nil
        }
    }
}



public protocol ChatConnectionDelegate {
    func chatConnection(_ connection: ChatConnection, new message: ChatMessage)
    func chatConnection(_ connection: ChatConnection, message: Long, changeStatusOn: DeliveryStatus)
}
extension ChatConnectionDelegate {
    public func chatConnection(_ connection: ChatConnection, new message: ChatMessage) {}
    public func chatConnection(_ connection: ChatConnection, message: Long, changeStatusOn: DeliveryStatus) {}
}
