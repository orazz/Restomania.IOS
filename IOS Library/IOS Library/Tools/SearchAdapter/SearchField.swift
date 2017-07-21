//
//  SearchField.swift
//  IOS Library
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

internal class SearchField<TElement> {

    private let _type: ValueType
    private let _filter: IFilter
    private let _getter: (TElement) -> Any

    internal init(_ type: ValueType, getter: @escaping (TElement) -> Any) {
        _type = type
        _getter = getter
        _filter = FiltersFactory.create(_type)
    }

    internal func search(phrase: String, in instance: TElement) -> Bool {
        return _filter.search(phrase: phrase, field: _getter(instance))
    }
}
