//
//  CachedProcessAdapter.swift
//  IOSLibrary
//
//  Created by Алексей on 28.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

open class CacheAdapterExtender<TElement> where TElement: ICached  {

    private let adapter: CacheRangeAdapter<TElement>

    public init(for adapter: CacheRangeAdapter<TElement>) {
        
        self.adapter = adapter
    }

    public var all: [TElement] {
        return adapter.data.map({ $0.data })
    }
    public func check(_ range: [Long]) -> CacheSearchResult<Long>{
        return adapter.checkCache(range)
    }
    public func find(_ id: Long) -> TElement? {
        return adapter.data.find({ $0.ID == id })?.data
    }
    public func find(_ predicate:@escaping ((TElement) -> Bool)) -> TElement? {

        if let result = adapter.data.find({ predicate($0.data) }) {
            return TElement(source: result.data)
        }
        else {
            return nil
        }
    }
    public func range(_ ids: [Long]) -> [TElement] {
        return adapter.data.where({ ids.contains($0.ID) }).map{ $0.data }
    }
    public func range(_ predicate: @escaping ((TElement) -> Bool)) -> [TElement] {
        return adapter.data.where({ predicate($0.data) }).map{ $0.data }
    }
    public func clear() {
        adapter.clear()
    }
}
