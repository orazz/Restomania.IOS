//
//  BaseApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class BaseApiService: ILoggable {
    private let _url = "http://restomania.eu"
    private let _tag: String
    internal let _client: ApiClient

    public init(area: String, tag: String) {
        self._tag = tag
        self._client = ApiClient(url: "\(_url)/\(area)", tag: _tag)
    }

    public var Tag: String {
        return _tag
    }
}
