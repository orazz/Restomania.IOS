//
//  Optional.swift
//  IOS Library
//
//  Created by Алексей on 20.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public class OptionalValue<T> {

    private let _value: T?

    public init(_ value: T?) {
        self._value = value
    }

    public var hasValue: Bool {
        return nil != _value
    }
    public var value: T {
        return _value!
    }
}
