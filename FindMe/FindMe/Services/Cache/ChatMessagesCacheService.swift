//
//  ChatMessagesCacheService.swift
//  FindMe
//
//  Created by Алексей on 24.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import AsyncTask
import IOSLibrary

public class ChatMessagesCacheService {

    private let tag = String.tag(ChatMessagesCacheService.self)
    private let guid = Guid.new
    private let cacheAdapter: CacheAdapter<ChatMessage>
    private let eventsAdapter: EventsAdapter<ChatMessagesCacheServiceDelegate>
    private let api = ApiServices.Chat.messages
    private let stream = StreamServices.chat
    private let apiQueue: AsyncQueue

    public var cache: CacheAdapterExtender<ChatMessage> {
        return cacheAdapter.extender
    }

    public init() {

        cacheAdapter = CacheAdapter<ChatMessage>(tag: tag, filename: "chat-messages.json", livetime: 365 * 24 * 60 * 60)
        eventsAdapter = EventsAdapter<ChatMessagesCacheServiceDelegate>(tag: tag)
        apiQueue = AsyncQueue.createForApi(for: tag)

        stream.subscribe(guid: guid, handler: self, tag: tag)
    }

    public func load() {
        cacheAdapter.loadCached()
    }
    public func clear() {
        cacheAdapter.clear()
    }

    //MARK: Methods
    public func new(with parameters: SelectParameters) -> RequestResult<[ChatMessage]> {

        Log.Debug(tag, "Request new messages.")
        return RequestResult<[ChatMessage]> { handler in

            let request = self.api.new(with: parameters)
            request.async(self.apiQueue) { response in

                if let update = response.data {
                    self.cacheAdapter.addOrUpdate(update)
                    self.eventsAdapter.invoke({ $0.messagesService(self, updates: update) })
                }

                handler(response)
            }
        }
    }
    public func all(from dialogId: Long, with parameters: SelectParameters) -> RequestResult<[ChatMessage]> {

        Log.Debug(tag, "Request messages for dialog #\(dialogId) (\(parameters.skip):\(parameters.take))")
        return RequestResult<[ChatMessage]> { handler in

            let request = self.api.all(from: dialogId, with: parameters)
            request.async(self.apiQueue) { response in

                if let update = response.data {
                    self.cacheAdapter.addOrUpdate(update)
                    self.eventsAdapter.invoke({ $0.messagesService(self, updates: update) })
                }

                handler(response)
            }
        }
    }


    public func send(_ message: SendingMessage) -> RequestResult<SourceChatMessage> {

        Log.Debug(tag, "Sending new message to dialog #\(message.dialogId).")
        return RequestResult<SourceChatMessage> { handler in

            let request = self.api.send(message)
            request.async(self.apiQueue) { response in

                if let message = response.data {
                    let wrapper = ChatMessage(wrap: message)
                    self.cacheAdapter.addOrUpdate(wrapper)
                    self.eventsAdapter.invoke({ $0.messagesService(self, new: wrapper) })
                }

                handler(response)
            }
        }
    }

    public func markAsDelivery(_ messageId: Long) -> RequestResult<Bool> {

        Log.Debug(tag, "Mark message #\(messageId) like delivered.")
        return RequestResult<Bool> { handler in

            let request = self.api.markAsDelivery(messageId)
            request.async(self.apiQueue) { response in

                if response.isSuccess,
                    let message = self.cache.find(messageId) {

                    message.deliveryStatus = .isDelivered
                    self.cacheAdapter.addOrUpdate(message)
                    self.eventsAdapter.invoke({ $0.messagesService(self, change: message) })
                }

                handler(response)
            }
        }
    }
    public func markAsRead(_ messageId: Long) -> RequestResult<Bool> {

        Log.Debug(tag, "Mark message #\(messageId) like read.")
        return RequestResult<Bool> { handler in

            let request = self.api.markAsRead(messageId)
            request.async(self.apiQueue) { response in

                if response.isSuccess,
                    let message = self.cache.find(messageId) {

                    message.deliveryStatus = .isRead
                    self.cacheAdapter.addOrUpdate(message)
                    self.eventsAdapter.invoke({ $0.messagesService(self, change: message) })
                }

                handler(response)
            }
        }
    }
}
extension ChatMessagesCacheService: ChatConnectionDelegate {
    public func chatConnection(_ connection: ChatConnection, new message: ChatMessage) {

        cacheAdapter.addOrUpdate(message)
        eventsAdapter.invoke({ $0.messagesService(self, new: message) })

        let request = markAsDelivery(message.ID)
        request.async(self.apiQueue)
    }
    public func chatConnection(_ connection: ChatConnection, message: Long, changeStatusOn status: DeliveryStatus) {

        if let message = cache.find(message) {

            message.deliveryStatus = status
            cacheAdapter.addOrUpdate(message)
            eventsAdapter.invoke({ $0.messagesService(self, change: message) })
        }
    }
}
extension ChatMessagesCacheService: IEventsEmitter {
    public typealias THandler = ChatMessagesCacheServiceDelegate

    public func subscribe(guid: String, handler: ChatMessagesCacheServiceDelegate, tag: String) {
        eventsAdapter.subscribe(guid: guid, handler: handler, tag: tag)
    }
    public func unsubscribe(guid: String) {
        eventsAdapter.unsubscribe(guid: guid)
    }
}



public protocol ChatMessagesCacheServiceDelegate {
    func messagesService(_ service: ChatMessagesCacheService, new message: ChatMessage)
    func messagesService(_ service: ChatMessagesCacheService, updates messages: [ChatMessage])
    func messagesService(_ service: ChatMessagesCacheService, change message: ChatMessage)
}
extension ChatMessagesCacheServiceDelegate {

    public func messagesService(_ service: ChatMessagesCacheService, new message: ChatMessage) {}
    public func messagesService(_ service: ChatMessagesCacheService, updates messages: [ChatMessage]) {}
    public func messagesService(_ service: ChatMessagesCacheService, change message: ChatMessage) {}
}
