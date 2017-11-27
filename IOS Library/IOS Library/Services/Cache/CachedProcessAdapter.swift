//
//  CachedProcessAdapter.swift
//  IOSLibrary
//
//  Created by Алексей on 28.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

open class CachedProcessAdapter<TElement> where TElement: ICached  {

    private let adapter: CacheRangeAdapter<TElement>

    public init(for adapter: CacheRangeAdapter<TElement>) {
        
        self.adapter = adapter
    }

    public var all: [TElement] {
        return adapter.localData
    }
    public func check(_ range: [Long]) -> CacheSearchResult<Long>{
        return adapter.checkCache(range)
    }
    public func find(_ placeId: Long) -> TElement? {
        return adapter.find(placeId)
    }
    public func range(_ range: [Long]) -> [TElement] {
        return adapter.range(range)
    }
    public func clear() {
        adapter.clear()
    }
}
