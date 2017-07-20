//
//  HttpStatusCode.swift
//  IOS Library
//
//  Created by Алексей on 15.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public enum HttpStatusCode: Int {
    case ConnectionError = 0
    case OK = 200
    case BadRequest = 400
    case Unauthorized = 401
    case Forbidden = 403
    case NotFound = 404
    case InternalServerError = 500
}
