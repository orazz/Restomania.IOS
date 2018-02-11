//
//  ChatMessagesApiService.swift
//  FindMe
//
//  Created by Алексей on 24.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class ChatMessagesApiService: BaseApiService {

    public init(configs: ConfigsStorage, keys: KeysStorage) {
        super.init(area: "Chat/Messages", configs: configs, tag: String.tag(ChatMessagesApiService.self), keys: keys)
    }

    //MARK: Methods
    public func new(with parameters: SelectParameters) -> RequestResult<[ChatMessage]> {

        let parameters = self.CollectParameters(rights: .user, [
            "parameters": parameters
        ])

        return self.client.GetRange(action: "New", type: ChatMessage.self, parameters: parameters)
    }

    public func all(from dialogId: Long, with parameters: SelectParameters) -> RequestResult<[ChatMessage]> {

        let parameters = self.CollectParameters(rights: .user, [
            "dialogId": dialogId,
            "parameters": parameters
        ])

        return self.client.GetRange(action: "All", type: ChatMessage.self, parameters: parameters)
    }


    public func send(_ message: SendingMessage) -> RequestResult<SourceChatMessage> {

        let parameters = self.CollectParameters(rights: .user, [
            "message": message
        ])

        return self.client.Post(action: "Send", type: SourceChatMessage.self, parameters: parameters)
    }


    public func markAsDelivery(_ messageId: Long) -> RequestResult<Bool> {

        let parameters = self.CollectParameters(rights: .user, [
            "messageId": messageId
        ])

        return self.client.PutBool(action: "MarkAsDelivered", parameters: parameters)
    }
    public func markAsRead(_ messageId: Long) -> RequestResult<Bool> {

        let parameters = self.CollectParameters(rights: .user, [
            "messageId": messageId
        ])

        return self.client.PutBool(action: "MarkAsRead", parameters: parameters)
    }
}
