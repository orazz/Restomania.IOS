//
//  ChatDialogsCacheService.swift
//  FindMe
//
//  Created by Алексей on 24.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import AsyncTask
import IOSLibrary

public class ChatDialogsCacheService {

    private let tag = String.tag(ChatDialogsCacheService.self)
    private let guid = Guid.new
    private let cacheAdapter: CacheAdapter<ChatDialog>
    private let eventsAdapter: EventsAdapter<ChatDialogsCacheServiceDelegate>
    private let api = ApiServices.Chat.dialogs
    private let stream = StreamServices.chat
    private let apiQueue: AsyncQueue

    public var cache: CacheAdapterExtender<ChatDialog> {
        return cacheAdapter.extender
    }

    public init() {

        cacheAdapter = CacheAdapter<ChatDialog>(tag: tag, filename: "chat-dialogs.json", livetime: 365 * 24 * 60 * 60)
        eventsAdapter = EventsAdapter<ChatDialogsCacheServiceDelegate>(tag: tag)
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
    public func all(with parameters: SelectParameters) -> RequestResult<[ChatDialog]> {

        Log.Debug(tag, "Request all dialogs (\(parameters.skip):\(parameters.take))")
        return RequestResult { handler in

            let request = self.api.all(with: parameters)
            request.async(self.apiQueue) { response in

                if let update = response.data {

                    self.cacheAdapter.clear()
                    self.cacheAdapter.addOrUpdate(update)
                    self.eventsAdapter.invoke({ $0.dialogsService(self, updates: update) })
                }

                handler(response)
            }
        }
    }
    public func find(_ dialogId: Long) -> RequestResult<ChatDialog> {

        Log.Debug(tag, "Request dialog #\(dialogId).")
        return RequestResult { handler in

            let request = self.api.find(dialogId)
            request.async(self.apiQueue) { response in

                if let dialog = response.data {

                    self.cacheAdapter.addOrUpdate(dialog)
                    self.eventsAdapter.invoke({ $0.dialogsService(self, update: dialog) })
                }

                handler(response)
            }
        }
    }

    public func partnersStatus(in dialogId: Long) -> RequestResult<[PartnerStatus]> {

        Log.Debug(tag, "Refresh statuses of partners for dialog #\(dialogId).")
        return RequestResult { handler in

            let request = self.api.partnersStatus(in: dialogId)
            request.async(self.apiQueue) { response in

                if let update = response.data,
                    let dialog = self.cache.find(dialogId) {

                    dialog.partners = update
                    self.cacheAdapter.addOrUpdate(dialog)
                    self.eventsAdapter.invoke({ $0.dialogsService(self, update: dialog) })
                }

                handler(response)
            }
        }
    }

    public func add(for recipientId: Long) -> RequestResult<ChatDialog> {

        Log.Debug(tag, "Create new dialog for user #\(recipientId).")
        return RequestResult { handler in

            let request = self.api.add(for: recipientId)
            request.async(self.apiQueue) { response in

                if let update = response.data {

                    self.cacheAdapter.addOrUpdate(update)
                    self.eventsAdapter.invoke({ $0.dialogsService(self, new: update) })
                }

                handler(response)
            }
        }
    }
    public func edit(_ dialogId: Long, by updates: [PartialUpdateContainer]) -> RequestResult<Bool> {

        Log.Debug(tag, "Update dialog #\(dialogId).")
        return RequestResult { handler in

            let request = self.api.edit(dialogId, by: updates)
            request.async(self.apiQueue) { response in handler(response) }
        }
    }
}

extension ChatDialogsCacheService: IEventsEmitter {
    public typealias THandler = ChatDialogsCacheServiceDelegate

    public func subscribe(guid: String, handler: ChatDialogsCacheServiceDelegate, tag: String) {
        eventsAdapter.subscribe(guid: guid, handler: handler, tag: tag)
    }
    public func unsubscribe(guid: String) {
        eventsAdapter.unsubscribe(guid: guid)
    }
}

extension ChatDialogsCacheService: ChatConnectionDelegate {
    public func chatConnection(_ connection: ChatConnection, new message: ChatMessage) {

        guard let dialog = cache.find(message.dialogId) else {
            _ = self.find(message.dialogId)
            return
        }

        dialog.lastMessage = message
        dialog.lastActivity = Date()
        self.cacheAdapter.addOrUpdate(dialog)
        self.eventsAdapter.invoke({ $0.dialogsService(self, update: dialog) })
    }
    public func chatConnection(_ connection: ChatConnection, message messageId: Long, changeStatusOn: DeliveryStatus) {

        guard let message = CacheServices.chatMessages.cache.find(messageId),
                let dialog = cache.find(message.dialogId) else {
            return
        }

        dialog.lastActivity = Date()
        self.cacheAdapter.addOrUpdate(dialog)
        self.eventsAdapter.invoke({ $0.dialogsService(self, update: dialog) })
    }
}



public protocol ChatDialogsCacheServiceDelegate {
    func dialogsService(_ service: ChatDialogsCacheService, new dialog: ChatDialog)
    func dialogsService(_ service: ChatDialogsCacheService, update dialog: ChatDialog)
    func dialogsService(_ service: ChatDialogsCacheService, updates dialogs: [ChatDialog])
}
extension ChatDialogsCacheServiceDelegate {
    public func dialogsService(_ service: ChatDialogsCacheService, new dialog: ChatDialog) {}
    public func dialogsService(_ service: ChatDialogsCacheService, update dialog: ChatDialog) {}
    public func dialogsService(_ service: ChatDialogsCacheService, updates dialogs: [ChatDialog]) {}
}
