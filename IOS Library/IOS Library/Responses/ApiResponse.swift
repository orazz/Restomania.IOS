//
//  ApiResponse.swift
//  IOS Library
//
//  Created by Алексей on 15.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Gloss

public class ApiResponse<TData>: Gloss.Decodable {

    public let statusCode: HttpStatusCode
    public let exception: String?
    public let reason: String?
    public var data: TData?

    public required init(json: JSON) {
        self.statusCode = ("StatusCode" <~~ json)!
        self.exception = "Exception" <~~ json
        self.reason = "Reason" <~~ json
        self.data = nil
    }
    public init(statusCode: HttpStatusCode) {
        self.statusCode = statusCode
        self.exception = nil
        self.reason = nil
        self.data = nil
    }

    public var isSuccess: Bool {

        return statusCode == .OK
    }
}
