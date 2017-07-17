//
//  ApiErrorResponse.swift
//  IOS Library
//
//  Created by Алексей on 15.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Gloss

public class ApiErrorResponse: ApiResponse {
    public let Exception: String
    public let Reason: String

    public required init(json: JSON) {
        self.Exception = ("Exception" <~~ json)!
        self.Reason = ("Reason" <~~ json)!

        super.init(json: json)
    }
}
