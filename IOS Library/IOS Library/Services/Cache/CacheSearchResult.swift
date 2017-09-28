//
//  CacheSearchResult.swift
//  IOSLibrary
//
//  Created by Алексей on 27.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public class CacheSearchResult<TType> {

    public let cached: [TType]
    public let notFound: [TType]



    public init(cached: [TType], notFound: [TType])
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
