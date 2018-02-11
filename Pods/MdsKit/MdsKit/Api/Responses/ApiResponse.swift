//
//  ApiResponse.swift
//  MdsKit
//
//  Created by Алексей on 15.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Gloss

public class ApiResponse<TData> {

    public let statusCode: HttpStatusCode
    public let exception: String?
    public let reason: String?
    public var data: TData?

    public let response: URLResponse?
    public let responseContent: String

    public required init(json: JSON, response: URLResponse?, content: String) {
        self.statusCode = ("StatusCode" <~~ json)!
        self.exception = "Exception" <~~ json
        self.reason = "Reason" <~~ json
        self.data = nil

        self.response = response
        self.responseContent = content
    }
    public init(statusCode: HttpStatusCode, response: URLResponse?) {
        self.statusCode = statusCode
        self.exception = nil
        self.reason = nil
        self.data = nil

        self.response = response
        self.responseContent = String.empty
    }

    public var isSuccess: Bool {
        return statusCode == .OK
    }
    public var isFail: Bool {
        return !isSuccess
    }
}
