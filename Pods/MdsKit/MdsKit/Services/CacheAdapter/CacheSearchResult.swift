//
//  CacheSearchResult.swift
//  MdsKit
//
//  Created by Алексей on 27.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public class CacheSearchResult<TType> {

    public let cached: [TType]
    public let notFound: [Long]



    public init(cached: [TType], notFound: [Long])
    {
        self.cached = cached
        self.notFound = notFound
    }


    public var isAllCached: Bool {
        return notFound.isEmpty
    }
    public var isNeedRequestNew: Bool {
        return !isAllCached
    }
}
