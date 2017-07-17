//
//  ApiResponse.swift
//  IOS Library
//
//  Created by Алексей on 15.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Gloss

public class ApiResponse: Decodable {
    public let StatusCode: HttpStatusCode

    public required init(json: JSON) {
        self.StatusCode = ("StatusCode" <~~ json)!
    }
    public init(statusCode: HttpStatusCode) {
        self.StatusCode = statusCode
    }
}
