//
//  ChatDialogsApiService.swift
//  FindMe
//
//  Created by Алексей on 24.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class ChatDialogsApiService: BaseApiService {

    public init(configs: ConfigsStorage, keys: KeysStorage) {
        super.init(area: "Chat/Dialogs", configs: configs, tag: String.tag(ChatDialogsApiService.self), keys: keys)
    }

    //MARK: Methods
    public func all(with parameters: SelectParameters) -> RequestResult<[Dialog]> {

        let parameters = self.CollectParameters(rights: .user, [
            "parameters": parameters
        ])

        return self.client.GetRange(action: "All", type: Dialog.self, parameters: parameters)
    }
    public func find(_ dialogId: Long) -> RequestResult<Dialog> {

        let parameters = self.CollectParameters(rights: .user, [
            "dialogId": dialogId
        ])

        return self.client.Get(action: "Find", type: Dialog.self, parameters: parameters)
    }
    public func partnersStatus(in dialogId: Long) -> RequestResult<[PartnerStatus]> {

        let parameters = self.CollectParameters(rights: .user, [
            "dialogId": dialogId
        ])

        return self.client.GetRange(action: "PartnersStatus", type: PartnerStatus.self, parameters: parameters)
    }



    public func add(for recipientId: Long) -> RequestResult<Dialog> {

        let parameters = self.CollectParameters(rights: .user, [
            "recipientId": recipientId
        ])

        return self.client.Post(action: "Add", type: Dialog.self, parameters: parameters)
    }
    public func edit(_ dialogId: Long, by updates: [PartialUpdateContainer]) -> RequestResult<Bool> {

        let parameters = self.CollectParameters(rights: .user, [
            "dialogId": dialogId,
            "updates": updates
        ])

        return self.client.PutBool(action: "Edit", parameters: parameters)
    }
}
