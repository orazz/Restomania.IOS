//
//  StreamServices.swift
//  FindMe
//
//  Created by Алексей on 23.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation

public class StreamServices {

    public static let chat: ChatConnection = ChatConnection(configs: ToolsServices.shared.configs, keys: ToolsServices.shared.keys)
}
