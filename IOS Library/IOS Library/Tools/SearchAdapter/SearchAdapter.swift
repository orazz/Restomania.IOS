//
//  SearchAdapter.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 21.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public class SearchAdapter<TElement> {

    private var _fields: [SearchField<TElement>]

    public init() {
        _fields = [SearchField]()
    }

    public func add(_ getter: @escaping (TElement) -> String) {
        _fields.append(SearchField<TElement>(.String, getter: getter))
    }
    public func add(_ getter: @escaping (TElement) -> Int) {
        _fields.append(SearchField<TElement>(.Number, getter: getter))
    }
    public func add(_ getter: @escaping (TElement) -> Date, type: ValueType) {
        _fields.append(SearchField<TElement>(type, getter: getter))
    }

    public func search(phrase: String, in instance: TElement) -> Bool {

        for field in _fields {
            if (field.search(phrase: phrase, in: instance)) {
                return true
            }
        }

        return false
    }
}
